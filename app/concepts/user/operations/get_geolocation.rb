class User::Operations::GetGeolocation < Trailblazer::Operation
  step ->(ctx, params:, policy:, **) {
    ctx[:model] = policy.find(params[:user_id])
  }, Output(:failure) => End(:not_found)

  # your code here
end
