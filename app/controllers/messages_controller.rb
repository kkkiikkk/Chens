class MessagesController < ApplicationController
  before_action :set_workspace
  before_action :set_chat
  before_action :check_user_in_chat, only: [:new, :create, :edit, :update, :destroy, :index, :marks_as_read]
  before_action :set_message, only: [:edit, :update, :destroy, :marks_as_read]
  before_action :current_user_not_blocked?, only: [:new, :create, :edit, :update, :index]

  def index
    @messages = @chat.messages.chronological
  end

  def create
    @message = @chat.messages.build(chat_params)
    @message.sender = current_user
    @message.sender_name = current_user.name

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to workspace_chat_messages_path(@workspace, @chat), notice: 'Message sent successfully.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @message.update(chat_params)
      respond_to do |format|
        format.turbo_stream
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

  def marks_as_read
    if @message.sender != current_user && !MessagePolicy.new(current_user, @message).seen?
      @message.message_reads.create!(user: current_user)
      ChatChannel.broadcast_to(@chat, {
        message_id: @message.id,
        action: 'message_seen',
        seen_by: @message.read_by_users.map(&:name)
      })
    end

    head :ok
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

  def current_user_not_blocked?
    user_workspace = @workspace.user_workspaces.find_by!(user_id: current_user.id)

    if UserWorkspacePolicy.new(current_user, user_workspace).blocked?
      redirect_to workspace_path(@workspace), alert: 'User had been blocked in this workspace'
    end
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
