# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:id) { |_n| rand(10_000..100_000_000) }
    sequence(:email) { |_n| "user#{rand(10_000..100_000_000)}@example.com" }
    name { 'test_name' }
    password { 'password123' }
    password_confirmation { 'password123' }
    confirmed_at { Time.now }
  end
end