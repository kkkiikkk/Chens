module ChatsService
  class Create < ApplicationService
    def call(current_user, params, workspace)
      @user = current_user
      @params = params
      @chat = Chat.new(chat_type: @params[:chat_type], chat_status: 'active', name: @params[:chat_name], workspace: workspace)

      if @params[:chat_type] == 'p2p'
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
        success({ text: "Chat was successfully created" })
      else
        failure({ text: "Chat can't be created. Please try again later." })
      end
    end

    def create_general_chat
      if @chat.save
        new_chat_member = ChatMember.new(user: @user, chat: @chat, role: 'owner')
        if new_chat_member.save
          success({ text: "Chat was successfully created" })
        else          
          failure({ text: "Chat can't be created. Please try again later." })
        end
      else
        failure({ text: "Chat can't be created. Please try again later." })
      end
    end
  end
end
