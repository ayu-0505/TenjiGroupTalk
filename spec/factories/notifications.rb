FactoryBot.define do
  factory :notification do
    read { false }
    user { nil }
    notifiable { nil }
  end
end
