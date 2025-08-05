FactoryBot.define do
  factory :talk do
    title { 'Talk Title' }
    description { 'Talk Text' }
    user
    group
  end
end
