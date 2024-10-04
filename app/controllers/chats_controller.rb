class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :require_workspace_owner!, only: [:create, :destroy]
  before_action :set_chat, only: [:edit, :update, :destroy]

  def index
    @chats = ChatsQuery.new(@workspace, current_user).all_chats
  end

  def show
    @chat = @workspace.chats.find_by(id: params[:id])
  
    if @chat.nil?
      redirect_to workspace_chats_path(@workspace), notice: 'Chat not found.'
      return
    end
  
    return if @chat.chat_type == 'public'
  
    unless @chat.chat_members.exists?(user_id: current_user.id)
      redirect_to workspace_chats_path(@workspace), notice: 'You cannot access this chat as you are not a member.'
    end
  end
  

  def new
  end

  def create
    result = ChatsService::Create.call(current_user, params, @workspace)
    if result.success?
      redirect_to workspace_chats_path(@workspace), notice: result[:payload]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @chat.update(update_chat_params)
      redirect_to workspace_chats_path(@workspace), notice: "Chat was succesfully updated"
    end
  end
  
  def destroy
    @chat.destroy
    redirect_to workspace_chats_path(@workspace), notice: 'Chat was successfully deleted.'
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:workspace_id])

    unless @workspace
      redirect_to workspaces_path, alert: 'Workspace not found or not accessible.'
    end
  end

  def set_chat
    @chat = @workspace.chats.find(params[:id])
  end

  def update_chat_params
    params.require(:chat).permit(:chat_status)
  end

  def require_workspace_owner!
    if !WorkspacePolicy.new(current_user, @workspace).owner? && params[:companion_id].empty?
      redirect_to workspaces_path, notice: 'You can not manage the chat because you are not workspace owner'
    end
  end

  def chat_member
    @chat.chat_members.find_by(user_id: current_user[:id])
  end
end
