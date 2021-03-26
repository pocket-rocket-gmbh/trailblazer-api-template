class Organization::Operations::Update < BaseOperation
  step ->(ctx, params:, **) { ctx[:model] = Organization.find_by(id: params[:organization_id]) }, Output(:failure) => End(:not_found) # FIXME.

  step Contract::Build( constant: Organization::Contracts::Update )
  step Contract::Validate()
  step Contract::Persist()

  fail :process_errors
end
