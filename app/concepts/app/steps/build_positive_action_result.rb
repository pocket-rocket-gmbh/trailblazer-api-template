# Sets http_status to 204
# Sets the json to an empty hash
class App::Steps::BuildPositiveActionResult < App::Steps::Base
  extend Uber::Callable

  def self.call(options, **)
    logger.debug "Executing #{self}"
    options['http_status'] = 204 if options['http_status'].nil?
    options['json'] = {}
  end
end
