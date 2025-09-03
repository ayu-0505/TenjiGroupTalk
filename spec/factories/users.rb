FactoryBot.define do
  factory :user do
    name { 'test_name' }
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:uid) { |n| "test_user#{n}" }
    image { ActionController::Base.helpers.asset_path('test_user_icon.png') }
    nickname { 'test_nick_name' }
  end
end
