class Organizations::Api < Grape::API

  resource :organizations do
    desc 'Retrieve a list of organizations'
    get do
      result = Organization::Operations::ListEndpoint.(params: params, request: request,
        path: 'v1/organizations',
        representer_class: Organization::Representers::Full)
      status result['http_status']
      result['json']
    end

    route_param :organization_id do
      desc 'Retrieve an organization'
      get do
        # show organization with id
        result = Organization::Operations::ShowEndpoint.(params: params, request: request,
          path: 'v1/organizations',
          representer_class: Organization::Representers::Full)
        status result['http_status']
        result['json']
      end
    end
  end
end
