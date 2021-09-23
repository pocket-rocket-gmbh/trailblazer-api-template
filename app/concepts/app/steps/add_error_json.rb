# Sets the json to an empty hash
class App::Steps::AddErrorJson < App::Steps::Base
  def self.call(options, domain_ctx:, **)
    logger.debug "Executing #{self}"
    error_hash = App::Representers::Error.new(result: domain_ctx).as_json
    logger.info error_hash
    if options['json'].nil?
      options['json'] = error_hash
    else
      options['json'] = options['json'].merge error_hash
    end
  end
end
