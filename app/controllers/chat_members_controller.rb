class ChatMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :set_chat
  before_action :set_chat_member
  before_action :require_permissions, only: [:new, :create, :edit, :update]
  before_action :require_owner!, only: [:edit, :update]

  def index
    @chat_members = @chat.chat_members
  end

  def new
    @chat_member = @chat.chat_members.new
  end

  def create
    @chat_member = @chat.chat_members.new(chat_member_params)
    @chat_member.role = 'member'
    if @chat_member.save
      redirect_to workspace_chats_path(@workspace), notice: 'User was successfully added to the chat'
    else
      render :new, alert: 'Failed creation. Try again'
    end
  end

  def destroy
    result = ChatMembersService::Destroy.call(target_chat_member(params[:id]), @chat_member)
    handle_result(result)
  end

  def edit
    @target_chat_member = target_chat_member(params[:id])
  end

  def update  
    update_params = update_chat_member_params
    result = ChatMembersService::ChangeRole.call(target_chat_member(params[:id]), @chat_member, update_params[:role])
    handle_result(result)
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:workspace_id])
    redirect_to workspaces_path, notice: 'Workspace not found or not accessible.' unless @workspace
  end

  def set_chat
    @chat = @workspace.chats.find(params[:chat_id])
  end

  def set_chat_member
    @chat_member = @chat.chat_members.find_by(user_id: current_user.id)
  end

  def target_chat_member(id)
    @target_chat_member ||= @chat.chat_members.find_by(id: id)  # Memoization to prevent redundant queries
  end

  def require_permissions
    if !ChatMemberPolicy.new(current_user, @chat_member).can_manage?
      redirect_to workspaces_path, alert: 'You do not have access to manage chat members'
    end
  end

  def require_owner!
    unless ChatMemberPolicy.new(current_user, @chat_member).owner?
      redirect_to workspaces_path, alert: 'Only owners can edit or update members'
    end
  end

  def chat_member_params
    params.require(:chat_member).permit(:user_id)
  end

  def update_chat_member_params
    params.require(:chat_member).permit(:role)
  end

  def handle_result(result)
    if result.success?
      redirect_to workspace_chats_path(@workspace), notice: result[:payload][:text]
    else
      redirect_to workspace_chats_path(@workspace), alert: result[:error]
    end
  end
end
