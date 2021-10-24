class Authentication::Api < Api::Base
  include Trailblazer::Endpoint::Grape::Controller

  def self.options_for_block_options(ctx, controller:, **)
    success_block = -> (ctx, endpoint_ctx:, jwt_token:, http_status:, **) do
      controller.header 'Authorization', "Bearer #{jwt_token}"
      controller.status http_status
      controller.body endpoint_ctx[:domain_ctx][:json]
    end

    failure_block = -> (ctx, http_status:, **) do
      controller.status http_status
    end

    {
      success_block:          success_block,
      failure_block:          failure_block,
      protocol_failure_block: failure_block,
    }
  end

  directive :options_for_block_options, method(:options_for_block_options)

  endpoint(
    Authentication::Operations::GenerateTokenEndpoint,
    protocol: App::Endpoint::Protocol::Authentication,
    adapter: Trailblazer::Endpoint::Adapter::API
  )

  resource :auth do
    post do
      endpoint(
        Authentication::Operations::GenerateTokenEndpoint,
        options_for_domain_ctx: { params: params }
      )
    end
  end
end
