class Friend < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  validates :status, inclusion: { in: %w[pending approved], message: "%{value} is not a valid status" }
  
  validate :cannot_friend_self

  scope :approved, -> { where(status: 'approved') }
  scope :pending, -> { where(status: 'pending') }
  scope :my, ->(user) { where(user1: user).or(where(user2: user)) }

  private

  def cannot_friend_self
    if user1 == user2
      errors.add(:user2, "You cannot be friends with yourself.")
    end
  end
end
