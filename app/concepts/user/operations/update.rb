class User::Operations::Update < BaseOperation
  step ->(ctx, params:, policy:, **) {
    ctx[:model] = policy.find(params[:user_id])
  }, Output(:failure) => End(:not_found)
  step Contract::Build( constant: User::Contracts::Update, builder: :default_contract! )
  step Contract::Validate()
  step Contract::Persist()
  step App::Steps::AddBase64ProfileImage
  step :update_password_if_requested

  fail :process_errors

  # todo: remove this if it works via reform
  def update_password_if_requested(options, model:, current_user:, params:, **)
    return true if !params[:password].present?
    if (current_user.role == 'admin' || current_user.role == 'root')
      model.password = params[:password]
    end
    model.save!
  end

  def default_contract!(options, constant:, model:, current_user:, **)
    constant.new(model, current_user: current_user)
  end
end
