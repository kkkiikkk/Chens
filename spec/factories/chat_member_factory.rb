# frozen_string_literal: true

FactoryBot.define do
  factory :chat_member do
    role { 'member' }
    chat
    user
  end
end