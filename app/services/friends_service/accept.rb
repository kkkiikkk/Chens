module FriendsService
  class Accept < ApplicationService
    def call(current_user, friend_request_id)
      @friend = expected_friend_request(friend_request_id, current_user)
      return failure('Friend request does not exist') unless @friend

      @friend.status = 'approved'

      if @friend.save
        success('Friend request was approved')
      else
        failure('Failed while accepting friend request')
      end
    end
  
    private

    def expected_friend_request(id, user)
      Friend.find_by(id: id, user2: user)
    end
  end
end