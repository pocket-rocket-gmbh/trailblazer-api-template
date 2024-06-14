class User::Operations::GetGeolocation < BaseOperation
  step ->(ctx, params:, policy:, **) {
    ctx[:model] = policy.find(params[:user_id])
  }, Output(:failure) => End(:not_found)
  step :search_coordinates
  step :update_coordinates

  fail :process_errors

  def search_coordinates(options, model:, **)
    results = Geocoder.search(model.geolocation_address)
    if results.blank?
      add_error options,
                message: 'No coordinates found!',
                exception: nil,
                code: 'get_geolocation.address_coordinates_not_found'
      return false
    end
    coordinates = results.first.coordinates
    options['lat'] = coordinates[0]
    options['long'] = coordinates[1]
    true
  end

  def update_coordinates(options, model:, **)
    model.update(latitude: options['lat'],
                 longitude: options['long'])
  end
end
