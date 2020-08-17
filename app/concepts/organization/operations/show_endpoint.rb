class Organization::Operations::ShowEndpoint < EndpointOperation
  step :set_defaults

  def set_defaults(options, **)
    options['model_class'] = Organization
    options['id_param'] = 'organization_id'
    true
  end

  step App::Steps::FindModel
  step App::Steps::BuildPositiveShowResult
  fail App::Steps::AddErrorJson
end
