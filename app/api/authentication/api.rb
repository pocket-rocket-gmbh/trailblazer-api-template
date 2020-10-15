class Authentication::Api < Grape::API
  resource :auth do
    extend Trailblazer::Endpoint::Controller

    endpoint(
      Authentication::Operations::GenerateTokenEndpoint,
      protocol: App::Endpoint::Protocol::Authentication,
      adapter: Trailblazer::Endpoint::Adapter::API
    )

    def self.options_for_block_options(ctx, controller:, **)
      success_block = -> (ctx, **) do
        controller.header 'Authorization', "Bearer #{ctx[:jwt_token]}"
        controller.status ctx[:http_status]
      end

      failure_block = -> (ctx, **) do
        controller.status ctx[:http_status]
      end

      {
        success_block:          success_block,
        failure_block:          failure_block,
        protocol_failure_block: failure_block,
      }
    end
    directive :options_for_block_options, method(:options_for_block_options)

    extend Trailblazer::Endpoint::Controller::InstanceMethods
    extend Trailblazer::Endpoint::Controller::InstanceMethods::API

    post do
      ctx = options[:for].endpoint(
        Authentication::Operations::GenerateTokenEndpoint,
        config_source: options[:for],
        controller: self,
        options_for_domain_ctx: { params: params }
      )

      ctx[:domain_ctx][:json]
    end
  end
end
