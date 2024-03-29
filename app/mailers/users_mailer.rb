class UsersMailer < ApplicationMailer

  def send_invitation(user)
    @user = user
    subject = "Du wurdest zur Trailblazer Service Plattform eingeladen"

    mail(to: @user.email, subject: subject)
  end

  def send_new_password(user)
    @user = user
    subject = "Dein neues Passwort in der Trailblazer Service Plattform"

    mail(to: @user.email, subject: subject)
  end
end
