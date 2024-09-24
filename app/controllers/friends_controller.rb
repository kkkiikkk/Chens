class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = Friend.approved.my(current_user)
  end

  def new
    @friend = Friend.new
  end

  def create
    p friend_params
    @friend = Friend.new
    
    # Convert user2 id from the params to a User object
    @friend.user1 = current_user
    @friend.user2 = User.find(friend_params[:user2])  # Find the user by ID

    if @friend.save
      redirect_to friends_path, notice: "Friendship request sent!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    # Logic to accept a friendship request
  end

  def destroy
    # Logic to destroy a friendship
  end

  private

  def friend_params
    params.require(:friend).permit(:user2)
  end
end
