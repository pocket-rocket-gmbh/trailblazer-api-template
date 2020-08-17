# Sets http_status to 200
# Sets the json to the according entity output using the representer_class given to the operation
class App::Steps::BuildPositiveShowResult < App::Steps::Base
  extend Uber::Callable

  def self.call(options, params:, request:, path:, representer_class:, **)
    logger.debug "Executing #{self}"
    options['http_status'] = 200 if options['http_status'].nil?
    options['json'] = App::Representers::Entity.new(result: options, request: request,
      path: path, representer_class: representer_class).as_json
  end

end
