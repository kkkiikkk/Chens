class UserWorkspace < ApplicationRecord
  belongs_to :user
  belongs_to :workspace

  has_one_attached :profile_avatar

  validates :profile_status, inclusion: { in: %w[away break online busy], message: "%{value} is not a valid status" }
end
