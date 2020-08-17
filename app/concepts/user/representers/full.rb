require 'roar/decorator'
require 'roar/json'

class User::Representers::Full < Roar::Decorator
  include Roar::JSON

  property :id
  property :email
  property :firstname
  property :lastname
  property :created_at
  property :updated_at
  property :organization_id
  property :status
  property :role

  property :organization do
    property :id
    property :name
    property :created_at
  end
end
