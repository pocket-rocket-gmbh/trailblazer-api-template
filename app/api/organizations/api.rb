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

    include Trailblazer::Endpoint::Controller::InstanceMethods
    def endpoint(name, **action_options)
      endpoint = endpoint_for(name, config: self)

      signal, (ctx, _) = advance_endpoint_for_controller(endpoint: endpoint, block_options: options_for(:options_for_block_options,
        controller: action_options[:controller]),  # DISCUSS: how to pass {:controller} around nicely?

        operation_class: name,


      **action_options)
      # invoke_endpoint_with_dsl(endpoint: endpoint, **action_options, &block)

      ctx[:json]
    end

    def endpoint_for(name, config: self.class)
        # options = options.merge(protocol_block: block || ->(*) { {} })
      config.options_for(:endpoints, {}).fetch(name) # TODO: test non-existant endpoint
      # puts Trailblazer::Developer.render(config.options_for(:endpoints, {}).fetch(name) )# TODO: test non-existant endpoint
    end

    def advance_endpoint_for_controller(endpoint:, block_options:, **action_options)
          domain_ctx, endpoint_options, flow_options = compile_options_for_controller(**action_options) # controller-specific, get from directives.

          endpoint_options = endpoint_options.merge(action_options) # DISCUSS

          Trailblazer::Endpoint::Controller.advance_endpoint(
            endpoint:      endpoint,
            block_options: block_options,

            domain_ctx:       domain_ctx,
            endpoint_options: endpoint_options,
            flow_options:     flow_options,
          )
        end

        # Requires {options_for}
        def compile_options_for_controller(options_for_domain_ctx: nil, config_source: self, **action_options)
          flow_options     = config_source.options_for(:options_for_flow_options, **action_options)
          endpoint_options = config_source.options_for(:options_for_endpoint, **action_options) # "class level"
          domain_ctx       = options_for_domain_ctx || config_source.options_for(:options_for_domain_ctx, **action_options)

          return domain_ctx, endpoint_options, flow_options
        end




    desc 'Retrieve a list of organizations'
    get do
      # App::Representers::List.new(
      # result: options,
      # request: request,
      # path: path,
      # representer_class: representer_class,
      # params: params,
      # countless: options['countless']

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
