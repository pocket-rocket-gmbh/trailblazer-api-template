class Organization::Operations::Create < BaseOperation
  step Model( Organization, :new )
  step Contract::Build( constant: Organization::Contracts::Create )
  step Contract::Validate()
  step Contract::Persist()

  fail App::Steps::SetUnprocessableHttpStatus
  fail :process_errors
end
