class UserWorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :set_user_workspace, only: [:edit, :update]

  def edit
  end

  def update
    if @user_workspace.update(user_workspace_params)
      redirect_to workspace_path(@workspace), notice: 'Your profile in the workspace was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user_workspace
    @user_workspace = @workspace.user_workspaces.find_by(user: current_user)

    unless @user_workspace
      redirect_to workspaces_path, alert: 'You are not associated with this workspace.'
    end
  end

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:id])
    unless @workspace
      redirect_to workspaces_path, alert: 'Workspace not found or not accessible.'
    end
  end

  def user_workspace_params
    params.require(:user_workspace).permit(
      :profile_description,
      :profile_name,
      :profile_status,
      :profile_title,
      :profile_avatar
    )
  end
end
