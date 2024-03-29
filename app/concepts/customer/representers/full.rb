class Customer::Representers::Full < Representable::Decorator
  include Representable::JSON

  property :id

  property :code
  property :company_name
  property :street
  property :zip
  property :city
  property :phone
  property :fax
  property :contact_person
  property :contact_person_position
  property :email

  property :created_at
  property :updated_at
end
