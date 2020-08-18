# Sets http_status to 422
class App::Steps::SetUnprocessableHttpStatus < App::Steps::Base
  extend Uber::Callable

  def self.call(options, params:, **)
    logger.debug "Executing #{self}"
    options['http_status'] = 422 if options['http_status'].nil?
    return false
  end
end
