module FriendsService
  class Create < ApplicationService
    def call(params, current_user)
      
    end

    private

    def expected_user(user_id)
      user = User.find_by(id: user_id)
      failure('User does not exists') unless user
      user
    end
  end
end