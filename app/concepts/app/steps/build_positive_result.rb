# Sets http_status to 201
# outputs a generic result (e.g. an Array of Strings)
class App::Steps::BuildPositiveResult < App::Steps::Base
  extend Uber::Callable

  def self.call(options, result:, **)
    logger.debug "Executing #{self}"
    options['http_status'] = 200 if options['http_status'].nil?

    options['json'] = result
  end
end
