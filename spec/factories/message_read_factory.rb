# frozen_string_literal: true

FactoryBot.define do
  factory :message_read do    
    user
    message
  end
end
