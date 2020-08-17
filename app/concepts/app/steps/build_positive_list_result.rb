# Sets http_status to 200
# Sets the json to the according list output
class App::Steps::BuildPositiveListResult < App::Steps::Base
  extend Uber::Callable

  def self.call(options, params:, request:, path:, representer_class:, **)
    logger.debug "Executing #{self}"
    options['http_status'] = 200 if options['http_status'].nil?
    options['json'] = App::Representers::List.new(
      result: options,
      request: request,
      path: path,
      representer_class: representer_class,
      params: params,
      countless: options['countless']
    ).as_json

    return true
  rescue => err
    logger.info "BuildPositiveListResult failed: #{err.message} ; backtrace: #{err.backtrace}"
    options['errors'] << { message: "List pagination, sorting or filtering failed: #{err.message}", exception: err, code: 'list.parameters.error'}
    options['http_status'] = 422
    return false
  end
end
