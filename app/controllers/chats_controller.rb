class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :require_workspace_owner!, only: [:new, :create, :destroy]

  def index
    @chats = ChatsQuery.new(@workspace, current_user).all_chats
  end

  def show
    @chat = @workspace.chats.find(params[:id])
  end

  def new
    @chat = @workspace.chats.new
  end

  def create
    result = ChatsService::Create.call(current_user, chat_params, @workspace)
    if result.success?
      redirect_to workspace_chats_path(@workspace), notice: result[:payload][:text]
    else
      @chat = @workspace.chats.new(chat_params)
      render :new
    end
  end
  
  

  def destroy
    @chat = @workspace.chats.find(params[:id])
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

  def chat_params
    params.require(:chat).permit(:name, :chat_type, :companion_id)
  end

  def require_workspace_owner!
    if !WorkspacePolicy.new(current_user, @workspace).owner?
      redirect_to workspaces_path, notice: 'You can not manage the chat because you are not workspace owner'
    end
  end
end
