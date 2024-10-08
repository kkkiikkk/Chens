# frozen_string_literal: true

FactoryBot.define do
  factory :chat_member do
    role { 'member' }
    chat
    user
    
    trait :member do
      role { 'member' }
    end

    trait :owner do
      role { 'owner' }
    end

    trait :moder do
      role { 'moder' }
    end
  end
end