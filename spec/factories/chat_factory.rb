# frozen_string_literal: true

FactoryBot.define do
  factory :chat do
    name { 'test_chat' }
    chat_type { 'public' }
    chat_status { 'active' }
    workspace
  end
end