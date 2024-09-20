class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :chat
  belongs_to :reply, class_name: 'Message', optional: true
  
  has_one_attached :image
end
