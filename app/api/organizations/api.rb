class Organizations::Api < Grape::API
  def self.assign_policy(ctx, policy:, domain_ctx:, **) # FIXME: use input?
    domain_ctx[:policy] = policy
  end

  resource :organizations do
    extend Trailblazer::Endpoint::Controller

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
    endpoint Organization::Operations::Create.to_s, domain_activity: Organization::Operations::Create do {} end
    endpoint Organization::Operations::Show.to_s, domain_activity: Organization::Operations::Show do {Output(:not_found) => End(:not_found)} end
    endpoint Organization::Operations::Update.to_s, domain_activity: Organization::Operations::Update do {Output(:not_found) => End(:not_found)} end
    endpoint Organization::Operations::Delete.to_s, domain_activity: Organization::Operations::Delete do {Output(:not_found) => End(:not_found)} end
    endpoint Organization::Operations::List.to_s, domain_activity: Organization::Operations::List, adapter: App::Endpoint::Adapter::List do
      step Organizations::Api.method(:assign_policy), before: :domain_activity
     {} end

    # include Trailblazer::Endpoint::Controller::InstanceMethods
    extend Trailblazer::Endpoint::Controller::InstanceMethods
    extend Trailblazer::Endpoint::Controller::InstanceMethods::API

    def endpoint(name, **action_options)
      ctx = super(name, operation_class: name, config_source: self, **action_options)
      ctx[:json]
    end

    desc 'Retrieve a list of organizations'
    get do
      @options[:for].endpoint(Organization::Operations::List.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full, controller: self)
    end

    desc 'Create an organization'
    post do                                                 # FIXME: we need strings as keys
      @options[:for].endpoint(Organization::Operations::Create.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full, controller: self, success_status: 201)
    end

    route_param :organization_id do
      desc 'Retrieve an organization'
      get do
        # FIXME: retrieve model via policy!
        @options[:for].endpoint(Organization::Operations::Show.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full, controller: self)
      end

      desc 'Update an organization'
      put do
        @options[:for].endpoint(Organization::Operations::Update.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full, controller: self)
      end

      desc 'delete an organization'
      delete do
        @options[:for].endpoint(Organization::Operations::Delete.to_s, path: 'v1/organizations', representer_class: Organization::Representers::Full, controller: self, success_status: 204)
      end
    end
  end
end
