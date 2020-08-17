# finds a model
class App::Steps::FindModel < App::Steps::Base
  extend Uber::Callable

  def self.call(options, params:, policy:, **)
    logger.debug "Executing #{self}"

    model_class = options['model_class']
    id_param = options['id_param']
    id = nil

    id = self.get_id_from_params(params: params, id_param: id_param)
    options['model'] = policy.find id

    return true
  rescue ActiveRecord::RecordNotFound => err
    options['errors'] << {
      message: "The #{model_class.to_s} with id: #{id} could not be found!",
      exception: err.class,
      code: "#{model_class.to_s.underscore}.not_found"
    }
    options['http_status'] = 404
    return false
  end

  def self.get_id_from_params(id_param:, params:, **)
    id = params[id_param]
    id = params[id_param.to_sym] if id.nil?
    id
  end
end
