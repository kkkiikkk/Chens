module FriendsService
  class Destroy < ApplicationService
    def call(id, current_user)
      @friend = expected_friend(id, current_user)

      if @friend.destroy
        success('Successfully deleted friend')
      else
        failure('Failed while deleting friend')
      end
    end

    private

    def expected_friend(id, user)
      friend = Friend.where(id: id, user1: user).or(Friend.where(id: id, user2: user)).first
      
      return failure('Friendship does not exist') unless friend
      friend
    end
  end
end
