# Base Classs for all pundit style policies
class App::Policies::Policy
  attr_reader :user, :model, :organization_id

  def initialize(user, model)
    @user = user
    raise "The given user is nil!" if @user.nil?
    @model = model
    raise "The given model class is nil!" if @model.nil?
    @organization_id = user.organization_id
    raise "The given user with id: #{user.id} has no assigned organization!" if @organization_id.nil?
  end

  def resolve
    raise NotImplementedError.new 'Not Implemented! Please implement me in the according sub-class!'
  end

  # all sub-implementations should raise an ActiveRecord::NotFound Exception when no object could be found
  def find(id)
    raise NotImplementedError.new 'Not Implemented! Please implement me in the according sub-class!'
  end

  protected

    # helper for calling UserPrivileges object with the current user in sub-classes
    def can_access?(endpoint, action)
      App::AccessPrivileges.can_access?(user.role, endpoint, action)
    end
end
