class Organization::Operations::CreateEndpoint < EndpointOperation
  step :call_nested
  step App::Steps::BuildPositiveCreateResult
  fail App::Steps::AddErrorJson

  def call_nested(options, params:, policy:, **)
    call_nested_logic_operation(Organization::Operations::Create, options,
      policy: policy, params: params)
  end
end
