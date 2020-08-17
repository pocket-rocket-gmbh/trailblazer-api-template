class Organization::Operations::ListEndpoint < EndpointOperation
  step :call_nested
  step App::Steps::BuildPositiveListResult
  fail App::Steps::AddErrorJson

  def call_nested(options, params:, policy:, **)
    call_nested_logic_operation(Organization::Operations::List, options, params: params,
      policy: policy)
  end
end
