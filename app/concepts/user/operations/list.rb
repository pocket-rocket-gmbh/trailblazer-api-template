class User::Operations::List < BaseOperation
  step :set_model_to_scoped_query
  step :retrieve_list
  fail :process_errors
end
