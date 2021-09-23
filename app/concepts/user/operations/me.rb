class User::Operations::Me < Trailblazer::Operation
  step ->(ctx, params:, current_user:, **) { ctx[:model] = current_user }, Output(:failure) => End(:not_found)
end
