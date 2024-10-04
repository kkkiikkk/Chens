module WorkspacesUserService
  class Block < ApplicationService
    def call(user_workspace)
      @user_workspace = user_workspace

      return failure('User workspace has already been blocked') if @user_workspace.blocked

      ActiveRecord::Base.transaction do
        block_user_workspace
        downgrade_chat_members_if_admin
      end

      success('User workspace was successfully blocked')
    rescue StandardError => e
      failure("User workspace could not be blocked: #{e.message}")
    end

    private

    def block_user_workspace
      @user_workspace.update!(blocked: true, role: downgrade_role_if_admin)
    end

    def downgrade_role_if_admin
      @user_workspace.role == 'admin' ? 'member' : @user_workspace.role
    end

    def downgrade_chat_members_if_admin
      @chat_members = ChatMember.where(user_id: @user_workspace.user_id, role: 'admin')

      @chat_members.each do |chat_member|
        chat_member.update!(role: 'member')
      end
    end
  end
end
