# Sets the json to an empty hash
class App::Steps::AddErrorJson < App::Steps::Base
  extend Uber::Callable

  def self.call(options, **)
    logger.debug "Executing #{self}"
    error_hash = App::Representers::Error.new(result: options).as_json
    logger.info error_hash
    if options['json'].nil?
      options['json'] = error_hash
    else
      options['json'] = options['json'].merge error_hash
    end
  end
end
