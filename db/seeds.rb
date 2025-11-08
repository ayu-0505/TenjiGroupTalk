# frozen_string_literal: true

return unless Rails.env.development?

Subscription.destroy_all
Notification.destroy_all
Invitation.destroy_all
Membership.destroy_all
Comment.destroy_all
Talk.destroy_all
Braille.destroy_all
Group.destroy_all
Talk.destroy_all
User.destroy_all

ORIGINAL_TEXTS = %w[てんじ いるか ことば こんにちわ ゆめ あさがお morning 100 ]

first_admin = User.create!(
  uid: 'first_admin',
  name: '点訳部つくる',
  email: 'user1@example.com',
  image: (ActionController::Base.helpers.asset_path 'test_user_icon.png'))

second_admin = User.create!(
  uid: 'second_admin',
  name: '兼任点字部長',
  email: 'user2@example.com',
  image: (ActionController::Base.helpers.asset_path 'test_user_icon.png'))

User.create!(
  uid: 'user_without_group',
  name: 'グループ未加入子',
  email: 'user3@example.com',
  image: (ActionController::Base.helpers.asset_path 'test_user_icon.png'))


user_with_multiple_groups = User.create!(
  uid: 'user_with_multiple_groups',
  name: 'グループ複数加入子',
  email: 'user4@example.com',
  image: (ActionController::Base.helpers.asset_path 'test_user_icon.png'))


User.create!(
  uid: 'deleted_user',
  nickname: 'サービスやめお',
  name: 'deleted_name',
  email: 'dummy_email_0000',
  image: (ActionController::Base.helpers.asset_path 'test_user_icon.png'),
  deleted_at: Time.current)

users = []
40.times do |n|
  user = User.create!(
          uid: "uid_user_0#{n}",
          name: "ユーザー#{n}",
          email: "other-user#{n}@example.com",
          nickname: "ニックネーム#{n}",
          image: (ActionController::Base.helpers.asset_path 'test_user_icon.png'))
  users << user
end

3.times do |n|
  group = Group.create!({
    name: "First Admin Group #{n}",
    admin_id: first_admin.id
  })

  first_admin.groups << group
  user_with_multiple_groups.groups << group
end

first_group = Group.find_by(name: 'First Admin Group 0')
second_admin.groups << first_group
users.each { |user| user.groups << first_group }

3.times do |n|
  group = Group.create!({
    name: "Second Admin Group #{n}",
    admin_id: second_admin.id
  })
  second_admin.groups << group
  user_with_multiple_groups.groups << group
end

10.times do |n|
  talk = Talk.create!({
    title: "Talk Title #{n}",
    description: "今日も楽しく点字を勉強しましょう。このトークは#{n}番目です。",
    user: first_admin,
    group: first_group
  })
  Subscription.create!({
    user: first_admin,
    talk:
  })
end

10.times do |n|
  braille = Braille.create(original_text: ORIGINAL_TEXTS.sample)
  talk = Talk.create!({
    title: "トークテーマ #{n}",
    description: "私もトークを作ってみました。このトークは#{n}番目です。",
    user: user_with_multiple_groups,
    group: first_group,
    braille:
  })
    Subscription.create!({
    user: first_admin,
    talk:
  })
end

20.times do |n|
  user = user_with_multiple_groups
  talk = first_group.talks.first
  braille = Braille.create!({
    original_text: ORIGINAL_TEXTS.sample,
    user:
  })
  comment = Comment.create!({
    description: "これはコメントです コメントナンバーは#{n}です",
    user:,
    talk:,
    braille:
  })
  Notification.create!({
    user: talk.user,
    comment:
  })
end
