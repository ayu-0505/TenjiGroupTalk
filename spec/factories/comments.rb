FactoryBot.define do
  factory :comment do
    sequence(:description) { |n| "Comment Text No.#{n}" }
    user
    talk
  end
end
