FactoryBot.define do
  factory :user_workspace do
    profile_status { 'online' }
    user
    workspace

    role { 'member' }

    trait :owner do
      role { 'owner' }
    end

    trait :member do
      role { 'member' }
    end
  end
end
