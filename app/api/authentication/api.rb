class Authentication::Api < Grape::API
  post :auth do
    result = Authentication::Operations::GenerateTokenEndpoint.(params: params, request: request)
    header 'Authorization', "Bearer #{result['jwt_token']}" if result['jwt_token']

    status result['http_status']
    result['json']
  end
end
