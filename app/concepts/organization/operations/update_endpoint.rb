class Organization::Operations::UpdateEndpoint < EndpointOperation
  step :call_nested
  step App::Steps::BuildPositiveShowResult
  fail App::Steps::AddErrorJson

  def call_nested(options, params:, policy:, **)
    call_nested_logic_operation(Organization::Operations::Update, options,
      policy: policy, params: params)
  end
end
