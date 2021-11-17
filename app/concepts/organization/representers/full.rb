class Organization::Representers::Full < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :status
  property :created_at
  property :updated_at
end
