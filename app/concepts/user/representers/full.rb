class User::Representers::Full < Representable::Decorator
  include Representable::JSON

  property :id
  property :email
  property :name
  property :firstname
  property :lastname
  property :created_at
  property :updated_at
  property :organization_id
  property :status
  property :role
  property :last_seen

  property :profile_image_url

  property :organization do
    property :id
    property :name
    property :created_at
  end

  property :permissions
end
