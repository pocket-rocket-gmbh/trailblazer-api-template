# Base class for all endpoint operations used in ces_api
# Provides convenience methods that are inherited by all sub-classes
class EndpointOperation < BaseOperation

  step Nested( Authentication::Operations::Authenticate )
  step :set_operation_class
  step Nested( Authentication::Operations::Authorize )

  step :strip_attributes

  def set_operation_class(options, **)
    options['operation_class'] = self.class
  end

  def strip_attributes(options, params:, **)
    logger.debug "Executing #{self}"
    params.each {|k, v| v.strip! if v.is_a?(String)}
    true
  end
end
