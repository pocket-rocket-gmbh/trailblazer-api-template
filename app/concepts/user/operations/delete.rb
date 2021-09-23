class User::Operations::Delete < BaseOperation
  step ->(ctx, params:, policy:, **) {
    ctx[:model] = policy.find(params[:user_id])
  }, Output(:failure) => End(:not_found)

  step App::Steps::DestroyModel
  fail :process_errors
end
