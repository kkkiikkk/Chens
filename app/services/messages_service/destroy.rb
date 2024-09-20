module MessagesService
  class Destroy < ApplicationService
    def call(message, current_user)
      @message = message
      @current_user = current_user
      @chat = message.chat

      if can_destroy_message?
        @message.destroy
        success({ text: 'Message successfully deleted.' })
      else
        failure('You are not authorized to delete this message.')
      end
    end

    private

    def can_destroy_message?
      message_owner? || chat_admin_or_owner?
    end

    def message_owner?
      @message.sender == @current_user
    end

    def chat_admin_or_owner?
      chat_member = @chat.chat_members.find_by(user_id: @current_user.id)
      ChatMemberPolicy.new(@current_user, chat_member).can_manage?
    end
  end
end
