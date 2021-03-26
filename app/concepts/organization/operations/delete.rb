class Organization::Operations::Delete < BaseOperation
  step ->(ctx, params:, **) { ctx[:model] = Organization.find_by(id: params[:organization_id]) }, Output(:failure) => End(:not_found) # FIXME

  step App::Steps::DestroyModel
  fail :process_errors
end
