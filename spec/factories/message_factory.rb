# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    text { 'some text' }
    chat
    association :sender, factory: :user
  end
end
