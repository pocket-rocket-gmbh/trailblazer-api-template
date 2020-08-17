class Organization::Api < Grape::API
  resource :organizations do
    desc 'Lists Organizations'
    get do
      Rails.logger.info "Received params: #{params}"
      result = Organizations::Operations::ListEndpoint.(
        params: params,
        request: request,
        path: 'v1/organizations'
      )
      status result['http_status']
      result['json']
    end
  end
end
