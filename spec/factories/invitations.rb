FactoryBot.define do
  factory :invitation do
    token { "MyString" }
    expires_at { "2025-07-03 10:43:06" }
    user { nil }
    group { nil }
  end
end
