require 'roar/decorator'
require 'roar/json'

class Organization::Representers::Full < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :status
  property :created_at
  property :updated_at
end
