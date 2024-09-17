module InvitesService
  class Create < ApplicationService
    include Rails.application.routes.url_helpers

    def call(workspace, invite, current_user)
      @invite = invite
      @invite.workspace = workspace
      @invite.user = current_user

      if InvitePolicy.new(current_user, @invite).private?
        @invite.save
        InviteMailer.invitation_email(@invite, workspace).deliver_now
        success({ text: 'Invite was sent to the user' })
      else
        @invite.save
        link = accept_invite_url(@invite.token, host: Rails.application.config.default_url_options[:host], port: Rails.application.config.default_url_options[:port] )
        success({ text: "Share your link: #{link}" })
      end
    end    
  end
end