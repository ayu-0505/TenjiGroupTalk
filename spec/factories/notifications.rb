FactoryBot.define do
  factory :notification do
    read { false }
    user
    comment
  end
end
