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

  def can_manage?
    ['owner', 'admin'].include?(record.role)
  end
end