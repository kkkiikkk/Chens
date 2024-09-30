module ChatMembersService
  class Destroy < ApplicationService
    def call(target_chat_member, chat_member)
      if can_destroy?(chat_member, target_chat_member)
        target_chat_member.destroy
        ChatMembersMailer.remove_from_the_chat(target_chat_member.user, target_chat_member.chat).deliver_now
        success(destroy_message(chat_member, target_chat_member))
      else
        failure('You cannot delete this member')
      end
    end

    private

    def can_destroy?(chat_member, target_chat_member)
      policy = ChatMemberPolicy.new(chat_member.user, chat_member)
      (policy.owner? && target_chat_member != chat_member) ||
        (policy.moder? && target_chat_member.role != 'moder') ||
        (policy.member? && target_chat_member == chat_member)
    end

    def destroy_message(chat_member, target_chat_member)
      if chat_member == target_chat_member
        "You've left the chat"
      else
        "You've deleted the user from the chat"
      end
    end
  end
end
