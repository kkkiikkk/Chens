class UnreadMessagesQuery
  def initialize(user)
    @user = user
  end

  def unread_messages
    Message
      .from_last_30_minutes
      .joins(:chat)
      .left_joins(:message_reads)
      .where(message_reads: { id: nil })
      .where.not(sender_id: @user.id)
  end
end
