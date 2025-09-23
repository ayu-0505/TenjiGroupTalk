FactoryBot.define do
  factory :notification do
    read { false }
    user

    factory :comment_notification do
      notifiable factory: :comment
    end
  end
end
