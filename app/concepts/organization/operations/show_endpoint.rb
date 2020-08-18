class Organization::Operations::ShowEndpoint < EndpointOperation
  self['model_class'] = Organization
  self['id_param'] = 'organization_id'

  step App::Steps::FindModel
  step App::Steps::BuildPositiveShowResult
  fail App::Steps::AddErrorJson
end
