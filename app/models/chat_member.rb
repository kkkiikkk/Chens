class ChatMember < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :role, inclusion: { in: %w[member owner moder], message: "%{value} is not a valid role" }
end
