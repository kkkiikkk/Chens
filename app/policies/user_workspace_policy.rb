class UserWorkspacePolicy < ApplicationPolicy
  def can_manage?
    ['admin', 'owner'].include?(@record.role)
  end

  def blocked?
    @record.blocked
  end
end