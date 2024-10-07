# frozen_string_literal: true

FactoryBot.define do
  factory :user_workspace do
    profile_status { 'online' }
    role
    user
    workspace
  end
end