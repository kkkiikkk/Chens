class ChatMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :set_chat
  before_action :set_chat_member, only: [:destroy, :index, :new, :create]
  before_action :require_admin_or_owner!, only: [:new, :create]

  def index
    @chat_members = @chat.chat_members
  end

  def new
    @chat_member = @chat.chat_members.new
  end

  def create
    @chat_member = @chat.chat_members.new(chat_member_params)
    @chat_member.role = 'member'
    @chat_member.chat = @chat
    if @chat_member.save
      redirect_to workspace_path, notice: 'User was succesfully added to the chat'
    else
      render :new, notice: 'Failed creation. Try again'
    end 
  end

  def destroy
    @chat_member.destroy
    redirect_to workspaces_path, notice: 'User were succesfully removed from the chat'
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: params[:workspace_id])
    unless @workspace
      redirect_to workspaces_path, notice: 'Workspace not found or not accessible.'
    end
  end

  def set_chat
    @chat = @workspace.chats.find(params[:chat_id])
  end

  def set_chat_member
    @chat_member = @chat.chat_members.find_by(user_id: current_user.id)
  end

  def require_admin_or_owner!
    if ChatMemberPolicy.new(current_user, @chat_member).member?
      redirect_to workspaces_path, notice: 'You can not manage chat members because you have no access'
    end
  end

  def chat_member_params
    params.require(:chat_member).permit(:user_id)
  end
end
