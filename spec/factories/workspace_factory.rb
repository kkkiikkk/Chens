# frozen_string_literal: true

FactoryBot.define do
  factory :workspace do
    name { 'Test workspace' }
    description { 'Test workspace description' }
    user
  end
end