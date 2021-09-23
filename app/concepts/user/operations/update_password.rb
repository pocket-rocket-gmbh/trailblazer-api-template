class User::Operations::UpdatePassword < BaseOperation
  step :set_model
  step :set_password

  fail :process_errors

  def set_model(options, current_user:, **)
    options['model'] = current_user
    true
  end

  def set_password(options, params:, current_user:, **)
    return true if params[:password].blank?

    valid_password = true

    if params[:password] != params[:password_confirmation]
      add_error options, message: 'Passwords not matching!', exception: nil, code: 'password.not_matching', field_name: 'password'
      valid_password = false
    end

    if params[:password].length < 5
      add_error options, message: 'Password too short!', exception: nil, code: 'password.too_short', field_name: 'password'
      valid_password = false
    end

    return false if !valid_password

    options['model'].password = params[:password]
    options['model'].save!
    true
  end
end
