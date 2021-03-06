module App::Endpoint
  class Protocol < Trailblazer::Endpoint::Protocol
    step Subprocess(Authentication::Operations::Authenticate), replace: :authenticate, id: :authenticate, inherit: true
    step Subprocess(Authentication::Operations::Authorize),    replace: :policy, id: :policy, inherit: true

    step :strip_attributes, before: :domain_activity

    Trailblazer::Endpoint::Protocol::Controller.insert_copy_to_domain_ctx!(self, {:current_user => :current_user})
    Trailblazer::Endpoint::Protocol::Controller.insert_copy_to_domain_ctx!(self, {:policy => :policy})

    # def strip_attributes(options, params:, **)
    def strip_attributes(options, domain_ctx:, **)
      domain_ctx[:params].each {|k, v| v.strip! if v.is_a?(String)}
      true
    end

    class Authentication < Protocol
      step nil, delete: :authenticate
      step nil, delete: :policy
    end
  end

  class Adapter < Trailblazer::Endpoint::Adapter::API
    step :assign_model
    step App::Steps::BuildPositiveCreateResult, id: :render

    step App::Steps::AddErrorJson, magnetic_to: :failure, Output(:success) => Track(:failure) # FIXME

    def assign_model(ctx, domain_ctx:, **) # DISCUSS: make this configurable?
      ctx[:model] = domain_ctx[:model]
    end

    class List < Adapter
      step App::Steps::BuildPositiveListResult, replace: :render
    end
  end
end
