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
    when 'admin', 'user'
      check_role_privileges? role, endpoint, action
    else
      raise "Unknow user role: #{role} !"
    end
  end

  # parameters which the user is allowed to access
  def self.attributes_allowed?(role, endpoint, params)
    case role
    when 'root'
      check_attributes_allowed? role, endpoint, params
    when 'admin', 'user'
      check_attributes_allowed? role, endpoint, params
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
        users: {
          me: true,
          list: false,
          list_internal: false,
          show: true,
          invite: false,
          update: true,
          update_password: true,
          delete: false
        },
        customers: {
          list: true,
          show: true,
          create: false,
          update: false,
          delete: false
        },
      },
      locked_attributes: {
        users: ['role', 'password']
      }
    }
  end

  def self.admin
    {
      role: 'admin',
      endpoints: {
        users: {
          me: true,
          list: true,
          list_internal: true,
          show: true,
          invite: true,
          update: true,
          update_password: true,
          delete: true
        },
        customers: {
          list: true,
          show: true,
          create: true,
          update: true,
          delete: true
        },
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
    # puts "Role: #{role} | endpoint: #{endpoint} | action: #{action} \nis_allowed: #{is_allowed}"
    is_allowed == true
  end

  def self.check_attributes_allowed?(role, endpoint, params)
    role = role.to_sym

    endpoint = endpoint.to_sym
    privileges = self.send(role.to_sym)

    locked_attributes = privileges.dig(:locked_attributes, endpoint)

    # check if params are included in blocked keys
    is_allowed = []
    if locked_attributes
      is_allowed = params.keys & locked_attributes
    end

    is_allowed == []
  end
end
