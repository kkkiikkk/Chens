class MessagesController < ApplicationController
  before_action :set_workspace
  before_action :set_chat
  before_action :check_user_in_chat, only: [:new, :create, :edit, :update, :destroy, :index]

  def index
    @messages = @chat.messages
  end

  def new
    @message = Message.new
  end

  def create
    @message = @chat.messages.build(chat_params)
    @message.sender = current_user

    if @message.save
      redirect_to workspace_chat_messages_path(@workspace, @chat), notice: 'Message sent successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
    if @message.update(chat_params)
      redirect_to workspace_chat_messages_path(@workspace, @chat), notice: 'Message updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @message = Message.find(params[:id])
    result = MessagesService::Destroy.call(@message, current_user)
  
    if result.success?
      redirect_to workspace_chat_messages_path(@workspace, @chat), notice: result[:payload][:text]
    else
      redirect_to workspace_chat_messages_path(@workspace, @chat), alert: result[:error]
    end
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:workspace_id])
    redirect_to workspaces_path, alert: 'Workspace not found or not accessible.' unless @workspace
  end
  
  def set_chat
    @chat = @workspace.chats.find_by(id: params[:chat_id])
    redirect_to workspace_chats_path(@workspace), alert: 'Chat not found.' unless @chat
  end

  def check_user_in_chat
    unless @chat.chat_members.exists?(user_id: current_user.id)
      redirect_to workspace_chats_path(@workspace), alert: 'You are not a member of this chat.'
    end
  end

  def chat_params
    params.require(:message).permit(:text, :image, :reply_id)
  end
end
