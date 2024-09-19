class ChatMemberPolicy < ApplicationPolicy
  def member?
    record.role == 'member'
  end

  def admin?
    record.role == 'admin'
  end

  def owner?
    record.role == 'owner'
  end

  def can_remove?
    ['owner', 'admin'].include?(record.role)
  end

  def can_add_members?
    ['owner', 'admin'].include?(record.role)
  end

  def owner_can_remove?
    !record_owner?
  end
end