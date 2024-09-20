class Chat < ApplicationRecord
  belongs_to :workspace
  has_many :chat_members
  has_many :messages

  validates :name, presence: true, unless: :p2p_chat?

  validates :chat_type, inclusion: { in: %w[public private p2p], message: "%{value} is not a valid type" }
  validates :chat_status, inclusion: { in: %w[active archive], message: "%{value} is not a valid type" }

  def private_or_p2p?
    chat_type.in?(%w[private p2p])
  end

  private

  def p2p_chat?
    chat_type == 'p2p'
  end
end
