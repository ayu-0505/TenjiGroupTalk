FactoryBot.define do
  factory :talk do
    sequence(:title) { |n| "Talk Title No.#{n}" }
    sequence(:description) { |n| "Talk Text No.#{n}" }
    user
    group
  end
end
