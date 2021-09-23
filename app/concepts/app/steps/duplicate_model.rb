# Sets http_status to 200
# outputs a generic result (e.g. an Array of Strings)
class App::Steps::DuplicateModel < App::Steps::Base
  extend Uber::Callable

  def self.call(options, model:, **)
    new_model = model.dup
    options['model'] = new_model
    options['model'].name = "[COPY] #{options['model'].name}"
    options['model'].save!
  end
end
