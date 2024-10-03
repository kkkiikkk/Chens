class UserWorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :set_user_workspace, only: [:edit, :destroy, :update, :block, :unblock]
  before_action :authorize_owner_or_self!, only: [:edit, :update, :destroy, :block, :unblock]
  before_action :current_user_not_blocked?, only: [:update, :edit]

  def index
    @user_workspaces = if params[:search].present?
                         UsersWorkspaceQuery.new(params[:search], @workspace).users_workspace
                       else
                         @workspace.user_workspaces
                       end
  end

  def edit
  end

  def update
    if @user_workspace.update(user_workspace_params)
      UserWorkspaceMailer.change_role(@user_workspace).deliver_now if ['admin'].include?(user_workspace_params[:role])
      redirect_to workspace_path(@workspace), notice: 'The profile in the workspace was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @user_workspace.user != current_user
      @user_workspace.destroy
      UserWorkspaceMailer.remove_user_workspace(@user_workspace.user, @workspace).deliver_now
      redirect_to workspace_path(@workspace), notice: 'User removed from workspace successfully.'
    else
      redirect_to workspace_path(@workspace), alert: 'You cannot remove yourself from the workspace.'
    end
  end

  def block
    result = WorkspacesUserService::Block.call(@user_workspace)

    if result.success?
      redirect_to workspace_path(@workspace), notice: result[:payload]
    else
      redirect_to workspace_path(@workspace), alert: result[:error]
    end
  end

  def unblock
    return redirect_to workspace_path(@workspace), alert: 'User are not blocked' unless @user_workspace.blocked
    @user_workspace.blocked = false

    if @user_workspace.save
      redirect_to workspace_path(@workspace), alert: 'User was succesfully unblocked'
    else
      redirect_to workspace_path(@workspace), alert: 'User cant be unblocked'
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

  def current_user_not_blocked?
    if UserWorkspacePolicy.new(current_user, @user_workspace).blocked?
      redirect_to workspace_path(@workspace), alert: 'You are blocked at this workspace.'
    end
  end

  def user_workspace_params
    permitted_params = [:profile_description, :profile_name, :profile_status, :profile_title, :profile_avatar]

    permitted_params << :role if current_user_is_owner?

    params.require(:user_workspace).permit(permitted_params)
  end
end
