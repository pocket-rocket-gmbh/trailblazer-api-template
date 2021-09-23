class Customer::Operations::Delete < BaseOperation
  step ->(ctx, params:, **) { ctx[:model] = Customer.find_by(id: params[:customer_id]) }, Output(:failure) => End(:not_found) # FIXME

  step App::Steps::DestroyModel
  fail :process_errors
end
