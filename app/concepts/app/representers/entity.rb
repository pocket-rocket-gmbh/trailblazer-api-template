# This representer is used for displaying a single result
class App::Representers::Entity
  attr_reader :result, :request, :path, :representer_class

  # @param result [Trailblazer::Operation::Result]
  # @param request The Request object of the http call
  # @param path [String]
  # @param representer_class The representer class to use for output
  # @param construct_subroute [Boolean] Should the result contain a subroute with id? (Default: true)
  def initialize(result:, request:, path:, representer_class:, construct_subroute: true)
    @result = result
    @request = request
    @path = path
    @representer_class = representer_class
    @construct_subroute = construct_subroute
  end

  def as_json
    resource_url = "/#{path}"
    resource_url = "/#{path}/#{result['model'].id}" if @construct_subroute
    {
      resource_url: resource_url,
      retrieved_at: DateTime.now.utc,
      # I added JSON.parse in order to be able to inject base_url in representer
      resource: JSON.parse(representer_class.new(result['model']).to_json(user_options: { base_url: request.base_url }))
    }
  end

end
