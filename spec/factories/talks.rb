FactoryBot.define do
  factory :talk do
    title { "MyString" }
    description { "MyText" }
    user { nil }
    group { nil }
  end
end
