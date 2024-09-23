class Chat < ApplicationRecord
  belongs_to :workspace
  has_many :chat_members
  has_many :messages

  validates :name, presence: true, unless: :p2p_chat?
  validates :chat_type, inclusion: { in: %w[public private p2p], message: "%{value} is not a valid type" }
  validates :chat_status, inclusion: { in: %w[active archive], message: "%{value} is not a valid type" }

  scope :public_chats, -> { where(chat_type: 'public') }
  scope :private_chats, -> { where(chat_type: 'private') }
  scope :p2p_chats, -> { where(chat_type: 'p2p') }
  scope :active, -> { where(chat_status: 'active') }
  scope :for_workspace, ->(workspace_id) { where(workspace_id: workspace_id) }
  scope :for_user, ->(user_id) { joins(:chat_members).where(chat_members: { user_id: user_id }) }

  def private_or_p2p?
    chat_type.in?(%w[private p2p])
  end

  private

  def p2p_chat?
    chat_type == 'p2p'
  end
end
