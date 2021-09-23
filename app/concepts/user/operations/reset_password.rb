class User::Operations::ResetPassword < PublicEndpointOperation
  step :check_user
  step User::Steps::SetPassword
  step :send_new_password_email
  step :set_generic_result
  step App::Steps::BuildPositiveGenericResult

  fail :process_errors

  def check_user(options, params:, **)
    return false if !params[:email]

    user = User.where("lower(email) = ?", params[:email].downcase).first

    if user
      options['model'] = user
      return true
    else
      add_error options, message: 'User not found!', exception: nil, code: 'reset_password.user_not_found'
      return false
    end
  end

  def set_generic_result(options, model:, **)
    options['result'] = { id: model.id, code: 'successfully.confirmed', message: 'New password was sent' }
    true
  end

  def send_new_password_email(options, model:, **)
    UsersMailer.send_new_password(model).deliver_now
    true
  end
end
