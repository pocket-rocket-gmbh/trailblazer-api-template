class User::Operations::ListInternal < BaseOperation
  step :set_model_to_scoped_custom_query
  step :retrieve_list
  fail :process_errors

  def set_model_to_scoped_custom_query(options, policy:, **)
    options['model'] = policy.resolve_internal
    return true
  end
end
