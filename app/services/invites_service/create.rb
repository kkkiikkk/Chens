module InvitesService
  class Create < ApplicationService
    include Rails.application.routes.url_helpers

    def call(workspace, invite, current_user, target_user)
      user_in_workspace(workspace, target_user)
      return failure('User already in workspace') if @expected_user

      @invite = invite
      @invite.workspace = workspace
      @invite.user = current_user
    
      if InvitePolicy.new(current_user, @invite).private?
        send_private_invite(workspace)
      else
        generate_invite_link
      end
    end

    private

    def user_in_workspace(workspace, target_user)
      @expected_user = workspace.user_workspaces.find_by(user: target_user)
    end

    def send_private_invite(workspace)
      if @invite.save
        InviteMailer.invitation_email(@invite, workspace).deliver_now
        success('Invite was sent to the user')
      else
        failure('Invite failed to save')
      end
    end

    def generate_invite_link
      if @invite.save
        link = accept_invite_url(@invite.token, host: Rails.application.config.default_url_options[:host], port: Rails.application.config.default_url_options[:port] )
        success("Share your link: #{link}")
      else
        failure('Invite failed to save')
      end
    end
  end
end