class UserWorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :set_user_workspace, only: [:edit, :update]
  before_action :authorize_owner_or_self!, only: [:edit, :update]

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
    @user_workspace = @workspace.user_workspaces.find_by(user_id: params[:user_id])

    unless @user_workspace
      redirect_to workspaces_path, alert: 'User workspace not found.'
    end
  end

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:workspace_id])

    unless @workspace
      redirect_to workspaces_path, alert: 'Workspace not found or not accessible.'
    end
  end

  def authorize_owner_or_self!
    unless current_user_is_owner? || current_user == @user_workspace.user
      redirect_to workspace_path(@workspace), alert: 'You are not authorized to edit this user’s workspace.'
    end
  end

  def current_user_is_owner?
    @workspace.user_workspaces.find_by(user_id: current_user.id, role: 'owner').present?
  end

  def user_workspace_params
    permitted_params = [:profile_description, :profile_name, :profile_status, :profile_title, :profile_avatar]

    permitted_params << :role if current_user_is_owner?

    params.require(:user_workspace).permit(permitted_params)
  end
end
