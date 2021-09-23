class Customers::Api < Grape::API
  def self.assign_policy(ctx, policy:, domain_ctx:, **) # FIXME: use input?
    domain_ctx[:policy] = policy
  end

  resource :customers do
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
        params: controller.params,

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
    endpoint Customer::Operations::Create
    endpoint Customer::Operations::Show do {Output(:not_found) => End(:not_found)} end
    endpoint Customer::Operations::Update do {Output(:not_found) => End(:not_found)} end
    endpoint Customer::Operations::Delete do {Output(:not_found) => End(:not_found)} end
    endpoint Customer::Operations::List, adapter: App::Endpoint::Adapter::List

    # include Trailblazer::Endpoint::Controller::InstanceMethods
    extend Trailblazer::Endpoint::Controller::InstanceMethods
    extend Trailblazer::Endpoint::Controller::InstanceMethods::API

    def endpoint(name, **action_options)
      ctx = super(name, operation_class: name, config_source: self, **action_options)
      ctx[:json]
    end

    desc 'Retrieve a list of all customers of the system'
    get do
      @options[:for].endpoint(Customer::Operations::List.to_s, path: 'v1/customers', representer_class: Customer::Representers::Full, controller: self)
    end

    desc 'Create customer'
    post do
      @options[:for].endpoint(Customer::Operations::Create.to_s, path: 'v1/customers', representer_class: Customer::Representers::Full, controller: self, success_status: 201)
    end

    route_param :customer_id do
      desc 'Retrieve a customer'
      get do
        @options[:for].endpoint(Customer::Operations::Show.to_s, path: 'v1/customers', representer_class: Customer::Representers::Full, controller: self)
      end

      desc 'Update a customer'
      put do
        @options[:for].endpoint(Customer::Operations::Update.to_s, path: 'v1/customers', representer_class: Customer::Representers::Full, controller: self)
      end

      desc 'Delete a customer'
      delete do
        @options[:for].endpoint(Customer::Operations::Delete.to_s, path: 'v1/customers', representer_class: Customer::Representers::Full, controller: self, success_status: 204)
      end
    end
  end
end
