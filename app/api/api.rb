# This is the main entry point for the API, it mounts all versions as sub-routes

class Api < Grape::API
  format :json

  mount ApiV1 => '/v1'
end
