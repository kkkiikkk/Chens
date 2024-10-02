class MessagePolicy < ApplicationPolicy
  def seen?
    @record.message_reads.exists?(user_id: @user.id)
  end
end