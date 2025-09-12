FactoryBot.define do
  factory :group do
    name { 'test_group' }
    admin factory: :user
  end
end
