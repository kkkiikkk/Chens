class UserWorkspaceMailer < ApplicationMailer
  def remove_user_workspace(user, workspace)
    @workspace = workspace
    @user = user

    mail(to: @user.email, subject: "You were removed from the #{@workspace.name} workspace")
  end

  def change_role(user_workspace)
    @user_workspace = user_workspace

    mail(to: @user_workspace.user.email, subject: 'Your role was updated')
  end
end