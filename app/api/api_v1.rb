class ApiV1 < Grape::API
  before do
    header "Access-Control-Allow-Credentials", true
    header "Access-Control-Allow-Origin", "*"
    header "Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization"
    header "Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS"
  end

  format :json

  mount Authentication::Api
  mount Organizations::Api
  mount Users::Api
  mount Customers::Api
end
