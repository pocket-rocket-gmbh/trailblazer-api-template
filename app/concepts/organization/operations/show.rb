class Organization::Operations::Show < Trailblazer::Operation
  # step Model(Organization, :find_by), input: {organization_id: :id, model_class: Organization}
  step ->(ctx, params:, **) { ctx[:model] = Organization.find_by(id: params[:organization_id]) }, Output(:failure) => End(:not_found)
end
