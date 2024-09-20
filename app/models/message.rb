class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :chat
  belongs_to :reply, class_name: 'Message', optional: true

  has_one_attached :image

  after_create_commit :broadcast_message

  private

  def broadcast_message
    ChatChannel.broadcast_to(chat, {
      message: render_message(self)
    })
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, chat: self.chat, workspace: self.chat.workspace })
  end
end
