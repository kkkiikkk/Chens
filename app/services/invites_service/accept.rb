module InvitesService
  class Accept < ApplicationService    
    def call(invite, current_user)
      failure('Invite does not exists') if invite.nil?
      @invite = invite
      @user = current_user
      @invite_policy = InvitePolicy.new(current_user, @invite)

      if @invite_policy.private?
        accept_private_invite
      else
        accept_public_invite
      end
      
    end

    private

    def accept_private_invite
      return failure('Invite already confirmed') if @invite_policy.confirmed?
      @invite.update(status: 'confirmed')
      
      assign_user_to_workspace
    end

    def accept_public_invite
      if @invite.workspace.users.exists?(@user.id)
        return failure('User is already in the workspace')
      end

      assign_user_to_workspace
    end

    def assign_user_to_workspace
      result = WorkspacesUserService::Create.call(@invite.workspace, @user, role: 'member')

      if result.success?
        success('User successfully joined the workspace')
      else
        success('User cant join the workspace. Try again later')
      end
    end
  end
end
