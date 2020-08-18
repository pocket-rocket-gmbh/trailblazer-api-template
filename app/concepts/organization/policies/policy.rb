class Organization::Policies::Policy < App::Policies::Policy
  def list?
    can_access? :organizations, :list
  end

  def show?
    can_access? :organizations, :show
  end

  def create?
    can_access? :organizations, :create
  end

  def update?
    can_access? :organizations, :update
  end

  def delete?
    can_access? :organizations, :delete
  end

  def resolve
    case user.role
    when 'root'
      model.all
    else
      model.where(id: user.organization_id)
    end
  end

  def find(id)
    case user.role
    when 'root'
      model.find id
    else
      raise ActiveRecord::RecordNotFound.new if id.to_s != user.organization_id.to_s
      model.find id
    end
  end
end
