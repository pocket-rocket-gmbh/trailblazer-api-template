# Sets the json to the according list output
class App::Steps::BuildPositiveListResult < App::Steps::Base
  def self.call(options, domain_ctx:, request:, path:, representer_class:, **)
    options['json'] = App::Representers::List.new(
      result: options,
      request: request,
      path: path,
      representer_class: representer_class,
      params: domain_ctx[:params],
      countless: options['countless'] || 0 # FIXME
    ).as_json

    return true
  # rescue => err
  #   puts err.inspect
  #   logger.info "BuildPositiveListResult failed: #{err.message} ; backtrace: #{err.backtrace}"
  #   options['errors'] << { message: "List pagination, sorting or filtering failed: #{err.message}", exception: err, code: 'list.parameters.error'}
  #   return false
  end
end
