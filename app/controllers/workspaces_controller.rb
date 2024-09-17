class WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace, only: [:show, :destroy, :edit, :update]

  def index
    @workspaces = current_user.workspaces
  end

  def show
    @user_workspace = @workspace.user_workspaces.find_by(user: current_user)
    @invite = @workspace.invites.new
    unless @user_workspace
      redirect_to workspaces_path, alert: 'You are not associated with this workspace.'
    end
  end

  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)
    @workspace.user = current_user

    result = WorkspacesUserService::Create.call(@workspace, current_user)

    if result.success?
      redirect_to workspaces_path, notice: 'Workspace was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @workspace.update(workspace_params)
      redirect_to workspace_path(@workspace), notice: 'Workspace was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if WorkspacePolicy.new(current_user, @workspace).can_destroy?
      @workspace.destroy
      redirect_to workspaces_path, notice: 'Workspace was successfully deleted.'
    else
      redirect_to workspaces_path, alert: 'You can not delete that workspace'
    end
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:id])
    unless @workspace
      redirect_to workspaces_path, alert: 'Workspace not found or not accessible.'
    end
  end

  def workspace_params
    params.require(:workspace).permit(:name, :description, :picture)
  end
end
