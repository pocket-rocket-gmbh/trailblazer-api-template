module App::Endpoint
  class Protocol < Trailblazer::Endpoint::Protocol
    def policy(*)
      true
    end

    step Subprocess(Authentication::Operations::Authenticate), replace: :authenticate, id: :authenticate
    step Subprocess(Authentication::Operations::Authorize), replace: :policy, id: :policy

      step :strip_attributes, before: :domain_activity

    # def strip_attributes(options, params:, **)
    def strip_attributes(options, domain_ctx:, **)
      domain_ctx[:params].each {|k, v| v.strip! if v.is_a?(String)}
      true
    end
  end

  class Adapter < Trailblazer::Endpoint::Adapter::API
    step :assign_model
    step App::Steps::BuildPositiveCreateResult
    step App::Steps::SetHttpStatus

    fail App::Steps::AddErrorJson # FIXME

    def assign_model(ctx, domain_ctx:, **) # DISCUSS: make this configurable?
      ctx[:model] = domain_ctx[:model]
    end
  end
end
