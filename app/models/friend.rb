class Friend < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  validates :status, inclusion: { in: %w[pending approved], message: "%{value} is not a valid status" }

  scope :approved_friends, -> { where(status: 'approved') }
  scope :my, ->(user) { where(user1: user).or(where(user2: user))  }

end
