# Sets the json to the according entity output using the representer_class given to the operation
class App::Steps::BuildPositiveResult < App::Steps::Base
  def self.call(options, request:, path:, representer_class:, **)
    logger.debug "Executing #{self}"

    options['json'] = App::Representers::Entity.new(result: options, request: request,
      path: path, representer_class: representer_class).as_json
  end
end
