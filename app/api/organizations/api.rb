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

    desc 'Create an organization'
    post do
      result = Organization::Operations::CreateEndpoint.(params: params, request: request,
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

      desc 'Update an organization'
      put do
        result = Organization::Operations::UpdateEndpoint.(params: params, request: request,
          path: 'v1/organizations',
          representer_class: Organization::Representers::Full
        )
        status result['http_status']
        result['json']
      end

      desc 'delete an organization'
      delete do
        result = Organization::Operations::DeleteEndpoint.(params: params, request: request)
        status result['http_status']
      end
    end
  end
end
