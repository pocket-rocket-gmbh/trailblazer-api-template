module App::Endpoint
  class Protocol < Trailblazer::Endpoint::Protocol
    def authenticate(*)
      true
    end

    def policy(*)
      true
    end
  end

  class Adapter < Trailblazer::Endpoint::Adapter::API

  end
end
