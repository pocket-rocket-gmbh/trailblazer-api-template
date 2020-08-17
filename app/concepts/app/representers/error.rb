# This representer is used for displaying error results

class App::Representers::Error
  attr_reader :result

  # @param result [Trailblazer::Operation::Result] An operation result object
  # @param request The Request object of the http call
  # @param path [String]
  def initialize(result:, **)
    @result = result
  end

  def as_json
    {
      errors: @result['errors'].map do |err_hash|
        {
          code: err_hash[:code],
          field_name: err_hash[:field_name],
          message: err_hash[:message],
          exception: err_hash[:exception].class.to_s
        }
      end
    }
  end

end
