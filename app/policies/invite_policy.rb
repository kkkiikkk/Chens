class InvitePolicy < ApplicationPolicy
  def confirmed?
    @record[:status] == 'confirmed'
  end

  def private?
    @record[:invite_type] == 'private'
  end
end
