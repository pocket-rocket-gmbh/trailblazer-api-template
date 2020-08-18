# destroys the Model in options['model']
class App::Steps::DestroyModel < App::Steps::Base
  extend Uber::Callable

  def self.call(options, model:, **)
    logger.debug "Executing #{self}"
    logger.debug "Destroying #{options['model'].class} with id: #{model.id}"
    model.destroy!
    true
  rescue StandardError => err
    options['errors'] << { message: err.message, exception: err, code: 'model.destroy_error'}
    return false
  end
end
