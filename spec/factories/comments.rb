FactoryBot.define do
  factory :comment do
    description { "MyText" }
    user { nil }
    talk { nil }
  end
end
