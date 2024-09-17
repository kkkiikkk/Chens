class InviteMailer < ApplicationMailer
  def invitation_email(invite, workspace)
    @invite = invite
    @workspace = workspace

    mail(to: @invite.email, subject: "You were invited to #{@workspace.name} workspace")
  end
end
