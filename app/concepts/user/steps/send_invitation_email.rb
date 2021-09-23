class User::Steps::SendInvitationEmail < App::Steps::Base
  extend Uber::Callable

  def self.call(options, model:, **)
    UsersMailer.send_invitation(model).deliver_now
    true
  end
end
