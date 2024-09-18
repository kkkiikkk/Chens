class WorkspacePolicy < ApplicationPolicy
  def can_destroy?
    record_owner?
  end

  def owner?
    record_owner?
  end
end
