class Customer::Operations::Update < BaseOperation
  step ->(ctx, params:, **) { ctx[:model] = Customer.find_by(id: params[:customer_id]) }, Output(:failure) => End(:not_found) # FIXME.

  step Contract::Build( constant: Customer::Contracts::Update )
  step Contract::Validate()
  step Contract::Persist()

  fail :process_errors
end
