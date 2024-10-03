module ChatsService
  class Create < ApplicationService
    def call(current_user, params, workspace)
      @user = current_user
      @params = params
      @chat = Chat.new(chat_type: @params[:chat_type], chat_status: 'active', name: @params[:chat_name], workspace: workspace)
      
      if @params[:chat_type] == 'p2p'
        if UserWorkspacePolicy.new(@user, user_workspace).blocked?
          return failure('Companion has been blocked')
        end
        create_p2p_chat
      else
        create_general_chat
      end
    end

    private

    def create_p2p_chat
      if @chat.save
        ChatMember.create!(user: @user, chat: @chat, role: 'owner')
        ChatMember.create!(user_id: @params[:companion_id], chat: @chat, role: 'owner')
        success("Chat was successfully created")
      else
        failure("Chat can't be created. Please try again later.")
      end
    end

    def create_general_chat
      if @chat.save
        ChatMember.create!(user: @chat.workspace.user, chat: @chat, role: 'owner')
        
        chat_members_data = chat_admins
        ChatMember.insert_all(chat_members_data) if chat_members_data.any?

        success("Chat was successfully created and admins assigned.")
      else
        failure("Chat can't be created. Please try again later.")
      end
    end

    def chat_admins
      admin_users = @chat.workspace.user_workspaces.where(role: 'admin')

      chat_members_data = admin_users.map do |admin_user_workspace|
        {
          user_id: admin_user_workspace.user_id,
          chat_id: @chat.id,
          role: 'admin',
          created_at: Time.current,
          updated_at: Time.current
        }
      end
    end

    def companion_workspace
      UserWorkspace.find_by!(user_id: @user.id, workspace_id: @workspace.id)
    end
  end
end
