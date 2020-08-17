class Authentication::Operations::GenerateTokenEndpoint < PublicEndpointOperation
  step Subprocess( Authentication::Operations::GenerateToken )
  step :build_json_response
  # do not forget to add json errors
  fail :set_error_status
  fail App::Steps::AddErrorsJson

  def build_json_response(options, **)
    options['http_status'] = 200
    options['json'] = {
      jwt_token: options['jwt_token'],
      permissions: App::AccessPrivileges.send(options['current_user'].role.to_sym),
      user: User::Representers::Full.new(options['current_user']).as_json
    }
  end

  def set_error_status(options, **)
    options['http_status'] = 401
  end
end
