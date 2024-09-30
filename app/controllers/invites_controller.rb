class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace, :set_user_workspace, only: [:new, :create]
  before_action :require_permissions!, only: [:new, :create]

  def new
    @invite = @workspace.invites.new
  end

  def create
    @invite = Invite.new(invite_params)
    result = InvitesService::Create.call(@workspace, @invite, current_user)
    
    if result.success?
      redirect_to workspace_path(@workspace), notice: result[:payload]
    else 
      redirect_to workspace_path(@workspace), alert: result[:error]
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

  def set_user_workspace
    @user_workspace = @workspace.user_workspaces.find_by(user: current_user)

    unless @user_workspace
      redirect_to workspace_path(@workspace), alert: 'You are not related to that workspace'
    end
  end

  def require_permissions!
    unless UserWorkspacePolicy.new(current_user, @user_workspace).can_manage?
      redirect_to workspace_path(@workspace), alert: 'You cant send invites'
    end
  end
end
