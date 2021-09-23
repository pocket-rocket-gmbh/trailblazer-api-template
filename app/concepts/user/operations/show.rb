class User::Operations::Show < Trailblazer::Operation
  # step Model(Organization, :find_by), input: {organization_id: :id, model_class: Organization}
  step ->(ctx, params:, policy:, **) {
    ctx[:model] = policy.find(params[:user_id])
  }, Output(:failure) => End(:not_found)
end
