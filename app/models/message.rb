class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :chat
  belongs_to :reply, class_name: 'Message', optional: true

  has_one_attached :image

  after_create_commit :broadcast_create_message
  after_update_commit :broadcast_update_message
  after_destroy_commit :broadcast_destroy_message

  private

  def broadcast_create_message
    ChatChannel.broadcast_to(chat, {
      message: render_message(self),
      action: 'create'
    })
  end

  def broadcast_update_message
    ChatChannel.broadcast_to(chat, {
      message: render_message(self),
      message_id: id,
      action: 'update'
    })
  end

  def broadcast_destroy_message
    ChatChannel.broadcast_to(chat, {
      message_id: id,
      action: 'destroy'
    })
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, chat: chat, workspace: chat.workspace })
  end
end
