class Organizations::Api < Api::Base
  include Trailblazer::Endpoint::Grape::Controller

  def self.assign_policy(ctx, policy:, domain_ctx:, **) # FIXME: use input?
    domain_ctx[:policy] = policy
  end

  # You have to define default behavior.
  def self.options_for_block_options(ctx, controller:, **)
    {
      success_block:          success_block = ->(ctx, endpoint_ctx:, **) { controller.status(endpoint_ctx[:status]); ctx['json'] }, # FIXME: {controller} comes from where?
      failure_block:          success_block,
      protocol_failure_block: success_block
    }
  end

  def self.options_for_domain_ctx(ctx, controller:, path:, representer_class:, **)
    {
      params:   controller.params,

      path: path,
      representer_class: representer_class,
    }
  end

  def self.options_for_endpoint(ctx, controller:, operation_class:, **)
    {
      request:         controller.request,
      operation_class: operation_class,
    }
  end

  directive :options_for_block_options, method(:options_for_block_options)
  directive :options_for_domain_ctx, method(:options_for_domain_ctx)
  directive :options_for_endpoint, method(:options_for_endpoint)

  endpoint protocol: App::Endpoint::Protocol, adapter: App::Endpoint::Adapter
  endpoint Organization::Operations::Create
  endpoint Organization::Operations::Show do {Output(:not_found) => End(:not_found)} end
  endpoint Organization::Operations::SneakIn do {Output(:not_found) => End(:not_found)} end
  endpoint Organization::Operations::Update do {Output(:not_found) => End(:not_found)} end
  endpoint Organization::Operations::Delete do {Output(:not_found) => End(:not_found)} end
  endpoint Organization::Operations::List, adapter: App::Endpoint::Adapter::List do
    step Organizations::Api.method(:assign_policy), before: :domain_activity
    {}
  end

  helpers do
    def endpoint(name, **action_options)
      ctx = super(name, operation_class: name, **action_options)
      ctx[:json]
    end
  end

  resource :organizations do
    desc 'Retrieve a list of organizations'
    get do
      endpoint(Organization::Operations::List.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full)
    end

    desc 'Create an organization'
    post do                                                 # FIXME: we need strings as keys
      endpoint(Organization::Operations::Create.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full, success_status: 201)
    end

    route_param :organization_id do
      desc 'Retrieve an organization'
      get do
        # FIXME: retrieve model via policy!
        endpoint(Organization::Operations::Show.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full)
      end

      desc 'Update an organization'
      put do
        endpoint(Organization::Operations::Update.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full)
      end

      desc 'delete an organization'
      delete do
        endpoint(Organization::Operations::Delete.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full, success_status: 204)
      end

      desc 'Sneak into an organization as root'
      get 'sneak_in' do
        endpoint(Organization::Operations::SneakIn.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full)
      end
    end
  end
end
