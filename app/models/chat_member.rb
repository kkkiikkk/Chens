class ChatMember < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :role, inclusion: { in: %w[member owner admin], message: "%{value} is not a valid role" }
  validate :chat_must_be_private_or_p2p

  private

  def chat_must_be_private_or_p2p
    unless chat.chat_type.in?(%w[private p2p])
      errors.add(:chat, 'must be private or p2p')
    end
  end
end
