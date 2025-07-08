FactoryBot.define do
  factory :user do
    name { 'test_name' }
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:uid) { |n| "test_user#{n}" }
    image { '/app/assets/images/default_user_icon' }
    nickname { 'test_nick_name' }
  end
end
