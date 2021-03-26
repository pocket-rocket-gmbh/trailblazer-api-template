class Authentication::Operations::Authorize < BaseOperation
  step :init_and_check_policy_result

  # Initialize the policy with the according name derived from the namespace of the endpoint operation
  # Executes the according check method for the endpoint operation
  # e.g. User::Operations::ListEndpoint -> initializes User::Policies::Policies::Policy -> executes policy method :list?
  # sets options['policy'] to the initialized policy object
  #
  # Breaks the circuit when the policy method returns false and adds error
  def init_and_check_policy_result(options, operation_class:, current_organization:, **)
    logger.debug "Executing init_and_check_policy_result"
    module_name = operation_class.to_s.split('::').first

    # construct check method name (AssignUsersEndpoint -> :assign_users?)
    check_method = "#{operation_class.to_s.split('::').last.gsub(
        'Endpoint', '').split(/(?=[A-Z])/).join('_').downcase}?".to_sym
    default_policy_class_name = "#{module_name}::Policies::Policy"

    # get policy class
    begin
      policy_class = default_policy_class_name.constantize
    rescue
      raise "No policy with name #{default_policy_class_name} could be found! Please define the policy for the namespace!"
    end

    # get specified model class or contantize it based on namespace
    begin
      model = options['model.class'] || module_name.constantize
    rescue
      raise "No model with name #{module_name} could be found!"
    end

    organization_id   = current_organization.id
    options['policy'] = policy_class.new(options['current_user'], model)

    unless options['policy'].respond_to?(check_method)
      raise "The policy #{default_policy_class_name} does not define the check method: #{check_method}. Please define the according method in the policy class!"
    end
    check_result = options['policy'].send(check_method)

    if check_result
      return true
    else
      logger.info "init_and_check_policy_result returned unauthorized!"
      add_error(options,
                message: "Endpoint Access forbidden!",
                exception: nil,
                code: "authorization.forbidden")
      options['http_status'] = 403
      return false
    end
  end
end
