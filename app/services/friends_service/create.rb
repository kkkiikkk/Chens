module FriendsService
  class Create < ApplicationService
    def call(params, current_user, new_friend)
      @friend = new_friend
    
      @friend.user1 = current_user
      @friend.user2 = expected_user(params[:user2])
      @friend.status = 'pending'

      if @friend.save
        success('Friend request has been sent')
      else
        failure('Failure save')
      end
    end

    private

    def expected_user(user_id)
      user = User.find_by(id: user_id)
      return failure('User does not exist') unless user
      user
    end
  end
end