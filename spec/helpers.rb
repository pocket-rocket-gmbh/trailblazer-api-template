# The Helpers module defines convenience methods for writing specs
module Helpers
  # Setup Helpers
  def setup_organization
    FactoryBot.create(:organization)
  end

  def setup_user_root(organization)
    FactoryBot.create(:user_root, organization: organization)
  end

  def setup_user(organization)
    FactoryBot.create(:user, organization: organization)
  end

  def setup_user_admin(organization)
    FactoryBot.create(:user_admin, organization: organization)
  end

  # -------- Request helpers ---------
  def request_headers(api_token = nil)
    headers = {
      'Content-Type' => 'application/json'
    }
    unless api_token.nil?
      headers.merge!(authorization_header(api_token))
    end
    headers
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
end
