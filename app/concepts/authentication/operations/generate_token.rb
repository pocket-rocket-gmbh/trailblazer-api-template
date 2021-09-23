require 'date'

class Authentication::Operations::GenerateToken < BaseOperation
  step :check_credentials
  step :check_token_expired
  step :generate_token
  step :process_errors

  def check_credentials(options, params:, **)
    logger.info "Executing check_credentials ..."
    email = params[:email]
    password = params[:password]

    if email.nil?
      add_error options,
        message: "No email provided! Could not authenticate user!",
        exception: nil,
        code: 'authentication.unauthorized',
        field_name: :email
      return false
    end

    # only downcase emails are allowed for users, always check with downcased email
    # We also downcase the search query here
    user = User.where("lower(email) = ?", email.downcase).first

    if is_user_invalid_for_login?(user, password)
      logger.info "Failed login attempt for email #{email} at #{Time.now}. Incorrect user/password combination ..."
      add_error options,
        message: "Incorrect user/password combination! Could not authenticate user!",
        exception: nil,
        code: 'authentication.unauthorized'
      return false
    end

    options['current_user'] = user
    options['current_user'].last_seen = Time.now
    options['current_organization_id'] = user.organization_id
  end

  def check_token_expired(options, **)
    logger.info "Executing check_token_expired for user with id: #{options['current_user'].id} ..."
    token = options['current_user'].jwt_token
    # exit early if no token is present for the user
    if token.nil?
      logger.info "No jwt_token found for user! Returning early!"
      return true
    end

    if !JwtService.expired?(token)
      logger.info "jwt_token for user is still valid"
      options['jwt_token'] = token
    else
      logger.info "jwt_token expired for user with id: #{options['current_user'].id} !"
    end
    return true
  end

  # example - https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api
  def generate_token(options, **)
    logger.info "Executing generate_token ..."
    # return if token does not need to be recreated
    return true unless options['jwt_token'].nil?
    logger.info "Generating new token for user with id: #{options['current_user'].id} ..."

    jwt = JwtService.generate('user_id', options['current_user'].id, {
      'email': options['current_user'].email,
      'user_id': options['current_user'].id,
      'organization_id': options['current_organization_id'],
      'role': options['current_user'].role
    })
    options['jwt_token'] = jwt
    options['current_user'].jwt_token = jwt
    options['current_user'].save
  end

private

  def is_user_invalid_for_login?(user, password)
    return true if user.nil?
    return true if user.status != 'confirmed'
    return !user.authenticate(password)
  end
end
