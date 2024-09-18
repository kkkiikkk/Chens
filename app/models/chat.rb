class Chat < ApplicationRecord
  belongs_to :workspace
  has_many :chat_members

  validates :name, presence: true
  validates :chat_type, inclusion: { in: %w[public private p2p], message: "%{value} is not a valid type" }
  validates :chat_status, inclusion: { in: %w[active archive], message: "%{value} is not a valid type" }

  def private_or_p2p?
    chat_type.in?(%w[private p2p])
  end
end
