FactoryBot.define do
  factory :invitation do
    sequence(:token) { |n| "token_No.#{n}" }
    expires_at { 7.days.from_now }
    user
    group
  end
end
