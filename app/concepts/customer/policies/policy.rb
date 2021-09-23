class Customer::Policies::Policy < App::Policies::Policy
  def list?
    can_access? :customers, :list
  end

  def show?
    can_access? :customers, :show
  end

  def create?
    can_access? :customers, :create
  end

  def update?
    can_access? :customers, :update
  end

  def delete?
    can_access? :customers, :delete
  end

  def resolve
    organization.customers
  end

  def find(id)
    organization.customers.find id
  end
end
