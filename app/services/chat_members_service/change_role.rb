module ChatMembersService
  class ChangeRole < ApplicationService
    def call(target_chat_member, chat_member, role)
      return failure('You cannot grant the role of owner to another user') if role == 'owner'
      
      if can_change_role?(chat_member, target_chat_member)
        update_role(target_chat_member, role)
      else
        failure('You cannot change user permissions')
      end
    end

    private

    def can_change_role?(chat_member, target_chat_member)
      ChatMemberPolicy.new(chat_member.user, chat_member).owner? &&
        target_chat_member.user != chat_member.user
    end

    def update_role(target_chat_member, role)
      target_chat_member.role = role
      if target_chat_member.save
        ChatMembersMailer.change_role(target_chat_member).deliver_now if target_chat_member.user.user_setting.notifications
        success('User role was successfully updated')
      else
        failure('Error while updating user role')
      end
    end
  end
end
