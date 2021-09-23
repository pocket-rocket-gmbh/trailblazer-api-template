class User::Contracts::Update < Reform::Form
  property :firstname
  property :lastname
  property :status
  property :role
  # property :password
  # property :current_user, virtual: true

  validation do
    params do
      optional(:role).filled(:string)
      # required(:current_user).filled
    end

    # TODO: make it impossible for some roles to edit its own role
    # rule(:role) do
    #   current_user = @values['current_user']
    #   do fancy shit here
    # end
  end
end
