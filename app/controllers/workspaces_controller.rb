class WorkspacesController < ApplicationController
  before_action :set_workspace, only: [:show, :destroy]

  def index
    @workspaces = Workspace.all
  end

  def show
  end

  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)
    if @workspace.save
      redirect_to workspaces_path, notice: 'Workspace was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @workspace.destroy
    redirect_to workspaces_path, notice: 'Workspace was successfully deleted.'
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:id])
  end

  def workspace_params
    params.require(:workspace).permit(:name, :description, :picture)
  end
end
