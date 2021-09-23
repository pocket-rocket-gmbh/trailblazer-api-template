class User::Operations::Invite < BaseOperation
  step Model( User, :new )
  step :scope_model_to_organization
  step Contract::Build( constant: User::Contracts::Invite )
  step Contract::Validate()
  step Contract::Persist()

  step User::Steps::SetPassword
  step User::Steps::SendInvitationEmail

  fail :process_errors
end
