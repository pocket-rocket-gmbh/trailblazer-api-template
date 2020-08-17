require 'uri'

class App::Representers::List
  attr_reader :result, :request, :path, :representer_class, :params, :collection, :current_page, :per_page, :countless

  def initialize(result:, request:, path:, representer_class:, params:, countless: false, **)
    @result            = result
    @request           = request
    @path              = path
    @representer_class = representer_class
    @params            = params
    @current_page      = result['pagination.page']
    @per_page          = result['pagination.per_page']
    @countless = countless
    @collection = if countless
                    result['model'].paginate(page: current_page, per_page: per_page + 1, total_entries: 0)
                  else
                    result['model']
                  end
  end

  def as_json
    if result['disable_pagination']
      return unpaginated_result
    end

    # return an empty result when no result is available
    if result.nil? || result['model'].nil?
      return {
        total_results: 0,
        total_pages: 0,
        current_page: 0,
        per_page: 0,
        current_url: current_url,
        prev_url: nil,
        next_url: nil,
        resources: []
      }
    end

    total_pages = collection.total_pages unless countless
    set_next_url = if countless
                     collection.to_a.size <= per_page
                   else
                     current_page >= total_pages
                   end
    set_prev_url = if countless
                     current_page <= 1
                   else
                     current_page <= 1 || current_page > total_pages
                   end

    if set_next_url
      next_url = nil
    else
      next_url = "#{request.host_with_port}/#{path}?page=#{current_page+1}&per_page=#{per_page}"
      next_url = URI::escape next_url
    end

    if set_prev_url
      prev_url = nil
    else
      prev_url = "#{request.host_with_port}/#{path}?page=#{current_page-1}&per_page=#{per_page}"
      prev_url = URI::escape prev_url
    end

    {
        total_results: (collection.count unless countless),
        total_pages: (total_pages unless countless),
        current_page: current_page,
        per_page: per_page,
        current_url: current_url,
        prev_url: prev_url,
        next_url: next_url,
        retrieved_at: DateTime.now.utc,
        resources: representer_class.for_collection.new(@collection).as_json
    }.compact
  end

  private

    def unpaginated_result
      # Counting array because it raises an exception in case of query with custom select
      # like we do for example with companies list endpoint
      collection_size = collection.to_a.count

      {
        total_results: collection_size,
        total_pages: 1,
        current_page: 1,
        per_page: collection_size,
        current_url: current_url,
        prev_url: nil,
        next_url: nil,
        resources: representer_class.for_collection.new(collection).as_json
      }
    end

    def current_url
      current_url = "#{request.host_with_port}/#{path}?page=#{current_page}&per_page=#{per_page}"
      URI::escape current_url
    end
end
