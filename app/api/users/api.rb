class Users::Api < Api::Base
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
  endpoint User::Operations::GetGeolocation do {Output(:not_found) => End(:not_found)} end
  endpoint User::Operations::Update do {Output(:not_found) => End(:not_found)} end
  endpoint User::Operations::UpdatePassword
  endpoint User::Operations::Delete do {Output(:not_found) => End(:not_found)} end
  endpoint User::Operations::List, adapter: App::Endpoint::Adapter::List
  endpoint User::Operations::ListInternal, adapter: App::Endpoint::Adapter::List

  helpers do
    def endpoint(name, **action_options)
      ctx = super(name, operation_class: name, **action_options)
      ctx[:json]
    end
  end

  resource :users do
    desc 'Retrieve my user'
    get '/me' do
      endpoint(User::Operations::Me.to_s, path: 'v1/users', representer_class: User::Representers::Full)
    end

    desc 'Retrieve a list of all users of the system'
    get do
      endpoint(User::Operations::List.to_s, path: 'v1/users', representer_class: User::Representers::Full)
    end

    desc 'Retrieve a list of internal users'
    get 'internal' do
      endpoint(User::Operations::ListInternal.to_s, path: 'v1/users', representer_class: User::Representers::Full)
    end

    desc 'Invite a new user to the organization'
    post do
      endpoint(User::Operations::Invite.to_s, path: 'v1/users', representer_class: User::Representers::Full, success_status: 201)
    end

    route_param :user_id do
      desc 'Retrieve a users geolocation'
      get 'geolocation' do
        endpoint(User::Operations::GetGeolocation.to_s, path: 'v1/users', representer_class: User::Representers::Full)
      end

      desc 'Retrieve a user'
      get do
        endpoint(User::Operations::Show.to_s, path: 'v1/users', representer_class: User::Representers::Full)
      end

      desc 'Update a user'
      put do
        endpoint(User::Operations::Update.to_s, path: 'v1/users', representer_class: User::Representers::Full)
      end

      desc 'Update a user password'
      put 'update-password' do
        endpoint(User::Operations::UpdatePassword.to_s, path: 'v1/users', representer_class: User::Representers::Full)
      end

      desc 'Delete a user'
      delete do
        endpoint(User::Operations::Delete.to_s, path: 'v1/users', representer_class: User::Representers::Full, success_status: 204)
      end
    end
  end
end
