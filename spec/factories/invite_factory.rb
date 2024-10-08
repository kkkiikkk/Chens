# frozen_string_literal: true

FactoryBot.define do
  factory :invite do
    invite_type { 'public' }
    status { 'unconfirmed' }
    email { 'test@email.com' }
    
    trait :confirmed do
      status { 'confirmed' }
    end

    trait :unconfirmed do
      status { 'unconfirmed' }
    end

    trait :public do
      invite_type { 'public' }
    end

    trait :private do
      invite_type { 'private' }
    end
    
    user
    workspace
  end
end
