class Customer::Operations::Show < Trailblazer::Operation
  step ->(ctx, params:, policy:, **) { ctx[:model] = Customer.find_by(id: params[:customer_id]) }, Output(:failure) => End(:not_found)
end
