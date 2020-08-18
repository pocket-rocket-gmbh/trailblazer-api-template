class Organization::Operations::Delete < BaseOperation
  self['model_class'] = Organization
  self['id_param'] = 'organization_id'

  step App::Steps::FindModel
  step App::Steps::DestroyModel
  fail :process_errors
end
