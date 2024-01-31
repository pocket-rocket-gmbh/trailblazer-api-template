class Authentication::Operations::Authenticate < BaseOperation
  step :verify_token
  step :is_token_expired?
  step :set_current_user
  step :set_current_organization

  def verify_token(options, request:, **)
    logger.debug "Executing verify_token"
    auth_header = request.headers['Authorization'] || request.headers['authorization']
    jwt_encoded_token = auth_header.split(' ').last
    options['encoded_jwt_token'] = jwt_encoded_token
    raise StandardError if JwtService.expired?(jwt_encoded_token)
    options['decoded_jwt_token'] = JwtService.decode(jwt_encoded_token)
    return true
  rescue StandardError => err
    logger.info "verify_token failed!"
    add_error options, message: 'Could not decode the given jwt token! Place your token in the Authentication header for http requests!',
              exception: nil, code: 'authentication.unauthorized'
    options['json'] = {}
    options['http_status'] = 401
    false
  end

  def is_token_expired?(options, **)
    logger.debug "Executing is_token_expired?"
    expiration_integer = options['decoded_jwt_token'].first['exp']
    return false if expiration_integer.nil?
    return false if (expiration_integer - DateTime.now.to_i) <= 0
    return true
  end

  def set_current_user(options, **)
    logger.debug "Executing set_current_user"
    user_id = options['decoded_jwt_token'].first['user_id']
    if user_id
      options['current_user'] = User.find_by!(
          jwt_token: options['encoded_jwt_token'],
          id: user_id
      )
      logger.info "current_user#role : #{options['current_user'].role}"
      logger.info "current_user#id : #{options['current_user'].id}"

      # update last_seen
      options['current_user'].last_seen = Time.now
      options['current_user'].save!
    end
    true
  rescue ActiveRecord::RecordNotFound => err
    logger.info "set_current_user failed!"
    add_error options, message: 'The given jwt token does not contain authorized user information!',
              exception: err, code: 'authentication.unauthorized'
    options['http_status'] = 401
    return false
  end

  def set_current_organization(options, **)
    logger.debug "Executing set_current_organization"

    # Not necessary for public requests
    if options['current_user']
      # dont allow connections for users that are not assigned to an organization
      if options['current_user'].organization.nil?
        add_error options, message: 'The user for the given jwt token is not assigned to an organization!',
                  exception: nil, code: 'authentication.unauthorized'
        options['http_status'] = 401
        return false
      end
      options['current_organization'] = options['current_user'].organization
    else
      current_organization = Organization.find(options['decoded_jwt_token'].first['organization_id'])
      options['current_organization'] = current_organization
    end

    # dont allow connections for users with disabled organizations
    if options['current_organization'].status != 'active'
      add_error options, message: 'The user\'s organization is inactive!',
                exception: nil, code: 'authentication.inactive_organization'
      options['http_status'] = 401
      return false
    end
    logger.info "current_organization#id : #{options['current_organization'].id}"
    options['current_organization']
  end
end
