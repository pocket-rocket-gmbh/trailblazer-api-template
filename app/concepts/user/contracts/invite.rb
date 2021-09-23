class User::Contracts::Invite < Reform::Form
  property :firstname
  property :lastname
  property :email
  property :status, default: 'confirmed'
  property :role

  validation do
    params do
      required(:email).filled(:string)
      required(:role).filled(:string)
    end

    rule(:email) do
      key.failure('must_be_valid') if !EmailValidator.regexp.match(value)
      key.failure('must_be_unique') if User.where(email: value.downcase).exists?
    end
  end
end
