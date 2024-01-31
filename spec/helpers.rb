# The Helpers module defines convenience methods for writing specs
module Helpers

  def setup_specs(version, endpoint)
    endpoint = "/#{version}/#{endpoint}"
    organization = self.setup_organization
    another_organization = self.setup_organization

    # setup users
    root   = self.setup_user_root(organization)
    admin  = setup_user_admin(organization)
    user   = setup_user(organization)

    # Login users to get tokens
    root_token = self.login(root.email, root.password)
    admin_token = self.login(admin.email, admin.password)
    user_token = self.login(user.email, user.password)

    # another user for testing out of scope requests
    another_admin  = setup_user_admin(another_organization)
    another_admin_token = self.login(another_admin.email, another_admin.password)

    return {
      endpoint: endpoint,
      organization: organization,
      root: root,
      admin: admin,
      user: user,
      root_token: root_token,
      admin_token: admin_token,
      user_token: user_token,
      another_organization: another_organization,
      another_admin: another_admin,
      another_admin_token: another_admin_token,
    }
  end

  # Setup Helpers
  def setup_organization
    FactoryBot.create(:organization)
  end

  def setup_user_root(organization)
    user = FactoryBot.create(:user_root, organization: organization)
    user
  end

  def setup_user(organization, role = 'user')
    user = FactoryBot.create(:user, organization: organization, role: role)
    user
  end

  def setup_business_unit_leader(organization)
    user = FactoryBot.create(:business_unit_leader, organization: organization, role: 'user')
    user
  end

  def setup_user_admin(organization)
    user = FactoryBot.create(:user_admin, organization: organization)
    user
  end

  # -------- Request helpers ---------
  def request_headers(api_token = nil, request_source = 'web')
    headers = {
      'Content-Type' => 'application/json',
      'Request-Source' => request_source,
      'Request-Platform' => 'something'
    }

    if request_source == 'app'
      headers['X-App-Version'] = '1.1.23'
      headers['X-App-Platfrom'] = 'Android'
    end

    unless api_token.nil?
      headers.merge!(authorization_header(api_token))
    end
    headers
  end

  def authorization_header_public_restricted(username, password)
    encoded_credentials = Base64.encode64("#{username}:#{password}")

    { 'Authorization' => "Basic #{encoded_credentials}"}
  end

  def authorization_header(api_token)
    { 'Authorization' => "Bearer #{api_token}"}
  end

  def parsed_response
    JSON.parse(response.body)
  end

  def login(email, password)
    post_json('/v1/auth', {'email': email, 'password': password})
    parsed_response['jwt_token']
  end

  def post_json(endpoint, params_hash, api_token = nil, headers={})
    post endpoint, params: params_hash.to_json, headers: request_headers(api_token).merge(headers)
  end

  def put_json(endpoint, params_hash, api_token = nil)
    put endpoint, params: params_hash.to_json, headers: request_headers(api_token)
  end

  def patch_json(endpoint, params_hash, api_token = nil)
    patch endpoint, params: params_hash.to_json, headers: request_headers(api_token)
  end

  def get_json(endpoint, params = nil, api_token = nil)
    get endpoint, params: params, headers: request_headers(api_token)
  end

  def delete_json(endpoint, params_hash, api_token = nil)
    delete endpoint, params: params_hash.to_json, headers: request_headers(api_token)
  end

  # app
  def post_json_app(endpoint, params_hash, api_token = nil, headers={})
    post endpoint, params: params_hash.to_json, headers: request_headers(api_token, 'app').merge(headers)
  end

  def get_json_app(endpoint, params_hash, api_token = nil, headers={})
    get endpoint, params: params_hash.to_json, headers: request_headers(api_token, 'app').merge(headers)
  end

  # public restricted
  def get_json_public(endpoint, params = nil, username, password)
    get endpoint, params: params, headers: authorization_header_public_restricted(username, password)
  end

  def post_json_public(endpoint, params = nil, username, password)
    post endpoint, params: params, as: :json, headers: authorization_header_public_restricted(username, password)
  end

  def put_json_public(endpoint, params = nil, username, password)
    put endpoint, params: params, headers: authorization_header_public_restricted(username, password)
  end
end
