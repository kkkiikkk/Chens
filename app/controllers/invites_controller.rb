class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace, only: [:new, :create]

  def new
    @invite = @workspace.invites.new
  end

  def create
    @invite = Invite.new(invite_params)
    result = InvitesService::Create.call(@workspace, @invite, current_user)
    
    if result.success?
      redirect_to workspace_path(@workspace), notice: result[:payload][:text]
    else 
      redirect_to workspace_path(@workspace), notice: result[:error]
    end
  end

  def accept
    @invite = Invite.find_by(token: params[:token])
    
    result = InvitesService::Accept.call(@invite, current_user)
    if result.success?
    else
    end
  end

  private
  
  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:workspace_id])
    unless @workspace
      redirect_to workspaces_path, alert: 'Workspace not found or not accessible.'
    end
  end

  def invite_params
    params.require(:invite).permit(:email, :invite_type)
  end
end