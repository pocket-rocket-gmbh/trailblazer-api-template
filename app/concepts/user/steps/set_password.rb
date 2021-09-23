class User::Steps::SetPassword < App::Steps::Base
  extend Uber::Callable

  def self.call(options, model:, params:, **)

    if params[:password].present?
      model.password = params[:password]
    else
      model.password = SecureRandom.hex(2)
    end

    model.status = :confirmed
    model.save!

    true
  end
end
