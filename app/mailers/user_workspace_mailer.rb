class UserWorkspaceMailer < ApplicationMailer
  def remove_user_workspace(user, workspace)
    @workspace = workspace
    @user = user

    mail(to: @user.email, subject: "You were removed from the #{@workspace.name} workspace")
  end
end