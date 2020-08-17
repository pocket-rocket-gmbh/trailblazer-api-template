# Container for general access rules for endpoints
#
# - Special conditions are handled in the according policies -
# e.g. a user with role 'user' wants to update a lead
# which is not in any of their organization
class App::AccessPrivileges

  def self.can_access?(role, endpoint, action)
    case role
    when 'root'
      return true
    when 'admin'
      check_role_privileges? role, endpoint, action
    when 'user'
      check_role_privileges? role, endpoint, action
    else
      raise "Unknow user role: #{role} !"
    end
  end

  def self.root
    {
      role: 'root'
    }
  end

  def self.user
    {
      role: 'user',
      endpoints: {
        # users: {
        #   me: true,
        #   list: true,
        #   update: true,
        # },
        # TODO: add missing permissions
      }
    }
  end

  def self.admin
    {
      role: 'admin',
      endpoints: {
        # users: {
        #   create: true,
        #   delete: true,
        #   disable: true,
        #   invite: true,
        #   list: true,
        #   me: true,
        #   show: true,
        #   update: true,
        #   import_from_xls: true,
        #   search: true,
        # },
        # TODO: add missing permissions
      }
    }
  end

private
  def self.check_role_privileges?(role, endpoint, action)
    role = role.to_sym
    endpoint = endpoint.to_sym
    action = action.to_sym
    privileges = self.send(role.to_sym)
    is_allowed = privileges.dig(:endpoints, endpoint, action)
    puts "Role: #{role} | endpoint: #{endpoint} | action: #{action} \nis_allowed: #{is_allowed}"
    is_allowed == true
  end
end
