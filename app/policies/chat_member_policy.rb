class ChatMemberPolicy < ApplicationPolicy
  def member?
    record.role == 'member'
  end

  def moder?
    record.role == 'moder'
  end

  def owner?
    record.role == 'owner'
  end

  def can_manage?
    ['owner', 'moder'].include?(record.role)
  end
end