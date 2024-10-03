class UsersWorkspaceQuery
  def initialize(user_name, workspace)
    @user_name = user_name
    @workspace = workspace
  end

  def users_workspace
    @workspace.user_workspaces.joins(:user)
             .where('users.name ILIKE ?', "%#{@user_name}%")
  end
end
