class Customer::Contracts::Create < Reform::Form
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

  validation do
    params do
      required(:code).filled(:string)
    end
  end
end
