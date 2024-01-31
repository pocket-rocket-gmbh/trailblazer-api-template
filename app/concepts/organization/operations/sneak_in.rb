class Organization::Operations::SneakIn < Trailblazer::Operation
  # step Model(Organization, :find_by), input: {organization_id: :id, model_class: Organization}
  step ->(ctx, params:, policy:, **) { ctx[:model] = policy.find(params[:organization_id]) }, Output(:failure) => End(:not_found)
  step :sneak_in

  def sneak_in(options, model:, current_user:, **)
    current_user.organization = model
    current_user.save!
    true
  end
end
