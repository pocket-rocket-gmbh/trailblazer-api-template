class Users::Api < Grape::API
  def self.assign_policy(ctx, policy:, domain_ctx:, **) # FIXME: use input?
    domain_ctx[:policy] = policy
  end

  resource :users do
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
    endpoint User::Operations::Me do {Output(:not_found) => End(:not_found)} end
    endpoint User::Operations::Invite
    endpoint User::Operations::Show do {Output(:not_found) => End(:not_found)} end
    endpoint User::Operations::Update do {Output(:not_found) => End(:not_found)} end
    endpoint User::Operations::UpdatePassword
    endpoint User::Operations::Delete do {Output(:not_found) => End(:not_found)} end
    endpoint User::Operations::List, adapter: App::Endpoint::Adapter::List
    endpoint User::Operations::ListInternal, adapter: App::Endpoint::Adapter::List

    # include Trailblazer::Endpoint::Controller::InstanceMethods
    extend Trailblazer::Endpoint::Controller::InstanceMethods
    extend Trailblazer::Endpoint::Controller::InstanceMethods::API

    def endpoint(name, **action_options)
      ctx = super(name, operation_class: name, config_source: self, **action_options)
      ctx[:json]
    end

    desc 'Retrieve my user'
    get '/me' do
      @options[:for].endpoint(User::Operations::Me.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self)
    end

    desc 'Retrieve a list of all users of the system'
    get do
      @options[:for].endpoint(User::Operations::List.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self)
    end

    desc 'Retrieve a list of internal users'
    get 'internal' do
      @options[:for].endpoint(User::Operations::ListInternal.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self)
    end

    desc 'Invite a new user to the organization'
    post do
      @options[:for].endpoint(User::Operations::Invite.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self, success_status: 201)
    end

    route_param :user_id do
      desc 'Retrieve a user'
      get do
        @options[:for].endpoint(User::Operations::Show.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self)
      end

      desc 'Update a user'
      put do
        @options[:for].endpoint(User::Operations::Update.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self)
      end

      desc 'Update a user password'
      put 'update-password' do
        @options[:for].endpoint(User::Operations::UpdatePassword.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self)
      end

      desc 'Delete a user'
      delete do
        @options[:for].endpoint(User::Operations::Delete.to_s, path: 'v1/users', representer_class: User::Representers::Full, controller: self, success_status: 204)
      end
    end
  end
end
