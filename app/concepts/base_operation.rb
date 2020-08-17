class BaseOperation < Trailblazer::Operation
  step :initialize_errors

  # -------------- Steps ---------------------
  # initialize the options['errors'] array
  def initialize_errors(options, **)
    options['errors'] = []
  end

  # --------------- Helpers -----------------

  # Adds an error to the options['errors'] hash
  #
  # @param options [Hash] the operation options that are passed along
  # @param message [String] a message to describe the exception
  # @param exception [StandardError] the exception
  # @param code [String] an identifier for the error
  # @param field_name [String] if it is a validation error: the name of the field that could not be validated
  def add_error(options, message:, exception: nil, code:, field_name: nil)
    options['errors'] << { code: code,
      message: message, exception: exception, field_name: field_name }
  end

  # @param options [Hash] the operation options that are passed along
  # @param errors [Array] an array of error objects to add to the errors array
  def add_errors(options, errors:)
    return if errors.count < 1
    errors.each do |err|
      add_error(options, message: err[:message], exception: err[:exception],
        field_name: err[:field_name], code: err[:code])
    end
  end

  # Adds errors from contracts when present
  # Logs errors to the logger
  def process_errors(options, **)
    add_contract_errors(options)
    log_errors(options)
  end

protected

  # iterates the contract errors and formats it to the options['errors'] format
  def add_contract_errors(options)
    if !options['contract.default'].nil? && options['contract.default'].respond_to?(:errors)
      options['contract.default'].errors.messages.each do |err|
        add_error options, message: "#{err.first} #{err.last.last}", code: "#{options['contract.default'].model.class.to_s.downcase}.#{err.first}.invalid", field_name: err.first
      end
    end
  end

  # Writes the options['errors'] array out using the logger
  #
  # @param options [Hash] the operation options that are passed along
  def log_errors(options)
    unless options['errors'].nil?
      options['errors'].each do |err_hash|
        logger.error("Code: #{err_hash[:code]} - FieldName: #{err_hash[:field_name]} - Exception: #{err_hash[:exception]} - #{err_hash[:message]}")
      end
    end
  end

  def logger
    Rails.logger
  end
end
