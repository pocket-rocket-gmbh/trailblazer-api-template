class Organization::Contracts::Create < Reform::Form
  property :name
  property :status
  property :email

  validation do
    params do
      required(:name).filled(:string)
    end
  end
end
