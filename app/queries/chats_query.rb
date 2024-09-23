class ChatsQuery
  def initialize(workspace, user)
    @workspace = workspace
    @user = user
  end

  def all_chats
    Chat.find_by_sql([combined_chats_sql])
  end

  private

  def combined_chats_sql
    <<-SQL
      (#{public_chats_sql.to_sql})
      UNION
      (#{private_chats_sql.to_sql})
      UNION
      (#{p2p_chats_sql.to_sql})
    SQL
  end

  def public_chats_sql
    Chat.public_chats.active.for_workspace(@workspace.id)
  end

  def private_chats_sql
    Chat.private_chats.active.for_workspace(@workspace.id).joins(:chat_members).where(chat_members: { user_id: @user.id })
  end

  def p2p_chats_sql
    Chat.p2p_chats.active.for_workspace(@workspace.id).joins(:chat_members).where(chat_members: { user_id: @user.id })
  end
end
