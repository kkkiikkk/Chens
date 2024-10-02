class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = Friend.approved.my(current_user)
    @sent_requests = Friend.pending.and(Friend.where(user1: current_user))
    @incoming_requests = Friend.pending.and(Friend.where(user2: current_user))
  end

  def new
    @friend = Friend.new
  end

  def create
    @friend = Friend.new
    response = FriendsService::Create.call(friend_params, current_user, @friend)
    handle_response(response)
  end

  def accept
    response = FriendsService::Accept.call(current_user, params[:id])
    handle_response(response)
  end

  def destroy
    response = FriendsService::Destroy.call(params[:id], current_user)
    handle_response(response)
  end

  private

  def friend_params
    params.require(:friend).permit(:user2)
  end

  def handle_response(response)
    if response.success?
      redirect_to friends_path, notice: response[:payload]
    else
      puts response[:error]
      redirect_to friends_path, notice: response[:error]
    end
  end  
end
