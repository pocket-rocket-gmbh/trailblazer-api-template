class User::Policies::Policy < App::Policies::Policy
  def me?
    can_access? :users, :me
  end

  def list?
    can_access? :users, :list
  end

  def list_internal?
    can_access? :users, :list_internal
  end

  def show?
    can_access? :users, :show
  end

  def invite?
    can_access? :users, :invite
  end

  def update?
    return (attributes_allowed?(:users) && can_access?(:users, :update))
  end

  def update_password?
    can_access? :users, :update_password
  end

  def delete?
    can_access? :users, :delete
  end

  def resolve
    organization.users.all
  end

  def resolve_internal
    organization.users.where(role: ['root', 'admin', 'user'])
  end

  def find(id)
    case user.role
    when 'root'
      model.find id
    when 'admin'
      organization.users.find id
    when 'user'
      user if user.id == id.to_i
    end
    rescue ActiveRecord::RecordNotFound => err
  end
end
