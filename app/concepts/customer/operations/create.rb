class Customer::Operations::Create < BaseOperation
  step Model( Customer, :new )
  step :scope_model_to_organization
  step Contract::Build( constant: Customer::Contracts::Create )
  step Contract::Validate()
  step Contract::Persist()

  fail :process_errors
end
