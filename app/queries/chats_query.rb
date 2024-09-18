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
    Chat.select('*')
        .where(workspace_id: @workspace.id, chat_type: 'public', chat_status: 'active')
  end

  def private_chats_sql
    Chat.select('chats.*')
        .joins(:chat_members)
        .where(workspace_id: @workspace.id, chat_type: 'private', chat_status: 'active')
        .where(chat_members: { user_id: @user.id })
  end

  def p2p_chats_sql
    Chat.select('chats.*')
        .joins(:chat_members)
        .where(workspace_id: @workspace.id, chat_type: 'p2p', chat_status: 'active')
        .where(chat_members: { user_id: @user.id })
  end
end
