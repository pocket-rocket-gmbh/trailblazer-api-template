class Organization::Operations::Update < BaseOperation
  self['model_class'] = Organization
  self['id_param'] = 'organization_id'

  step App::Steps::FindModel
  step Contract::Build( constant: Organization::Contracts::Update )
  step Contract::Validate()
  step Contract::Persist()

  fail App::Steps::SetUnprocessableHttpStatus
  fail :process_errors
end
