class InviteMailer < ApplicationMailer
  def invitation_email(invite, workspace)
    @invite = invite
    puts "WORKSPACE - #{workspace}"
    p workspace
    @workspace = workspace

    mail(to: @invite.email, subject: "You were invited to #{@workspace.name} workspace")
  end
end
