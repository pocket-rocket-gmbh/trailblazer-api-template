# Base Classs for all pundit style policies
class App::Policies::Policy
  attr_reader :user, :organization, :model, :organization_id, :params

  def initialize(user, model, params)
    @params = params
    @user = user
    raise "The given user is nil!" if @user.nil?
    @organization = user.organization

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

  # if we want to search a model
  def construct_search_query(query, fields, exact_match)
    return '' if query.nil? || query.empty?
    words = query.split(' ')
    query = ""

    words.each do |word|
      word.downcase.strip!
      sub_query ||= ""
      matcher = exact_match ? "'#{word}%'" : "'%#{word}%'"
      fields.each do |field|
        sub_query += " OR " if sub_query.length > 0
        if field == :id
          sub_query = "#{sub_query}#{field.to_s} = #{word.to_i}"
        else
          sub_query = "#{sub_query}#{field.to_s} ILIKE #{matcher}"
        end
      end
      if query.empty?
        query = sub_query
      else
        query = "#{query} AND #{sub_query}"
      end
    end
    query
  end

  protected

    # helper for calling UserPrivileges object with the current user in sub-classes
    def can_access?(endpoint, action)
      App::AccessPrivileges.can_access?(user.role, endpoint, action)
    end

    # helper to check if user is allowed to perform updates on certain attributes
    def attributes_allowed?(endpoint)
      App::AccessPrivileges.attributes_allowed?(user.role, endpoint, @params)
    end
end
