class MessagesController < ApplicationController
  before_action :set_workspace
  before_action :set_chat
  before_action :check_user_in_chat, only: [:new, :create, :edit, :update, :destroy, :index]
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    @messages = @chat.messages
  end

  def create
    @message = @chat.messages.build(chat_params)
    @message.sender = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to workspace_chat_messages_path(@workspace, @chat), notice: 'Message sent successfully.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @message.update(chat_params)
      respond_to do |format|
        format.html { redirect_to workspace_chat_messages_path(@workspace, @chat), notice: 'Message updated successfully.' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to workspace_chat_messages_path(@workspace, @chat), notice: 'Message deleted.' }
    end
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find_by!(id: params[:workspace_id])
  end
  
  def set_chat
    @chat = @workspace.chats.find_by!(id: params[:chat_id])
  end

  def set_message
    @message = @chat.messages.find(params[:id])
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
