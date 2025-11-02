# frozen_string_literal: true

ORIGINAL_TEXTS = %w[てんじ いるか ことば こんにちわ ゆめ あさがお morning 100 ]

first_admin = User.find_or_create_by!(uid: 'first_admin') do |user|
  user.name = '点訳部つくる'
  user.email = 'user1@example.com'
  user.image = ActionController::Base.helpers.asset_path('test_user_icon.png')
end

second_admin = User.find_or_create_by!(uid: 'second_admin') do |user|
  user.name = '兼任点字部長'
  user.email = 'user2@example.com'
  user.image = ActionController::Base.helpers.asset_path('test_user_icon.png')
end

User.find_or_create_by!(uid: 'user_without_group') do |user|
  user.name = 'グループ未加入子'
  user.email = 'user3@example.com'
  user.image = ActionController::Base.helpers.asset_path('test_user_icon.png')
end

user_with_multiple_groups = User.find_or_create_by!(uid: 'user_with_multiple_groups') do |user|
  user.name = 'グループ複数加入子'
  user.email = 'user4@example.com'
  user.image = ActionController::Base.helpers.asset_path('test_user_icon.png')
end

User.find_or_create_by!(uid: 'deleted_user') do |user|
  user.nickname = 'サービスやめお'
  user.name = 'deleted_name'
  user.email = 'dummy_email_0000',
  user.uid = 'dummy_uid_0000'
  user.deleted_at = Time.current
end

users = []
40.times do |n|
  user = User.find_or_create_by!(uid: "uid_user_0#{n}") do |u|
           u.name = "ユーザー#{n}"
           u.email = "other-user#{n}@example.com",
           u.uid = "uid_other_user_#{n}",
           u.nickname = "ニックネーム#{n}",
           u.image = ActionController::Base.helpers.asset_path('test_user_icon.png')
         end
  users << user
end

3.times do |n|
  unless Group.exists?(name: "First Admin Group #{n}")
    group = Group.create!({
      name: "First Admin Group #{n}",
      admin_id: first_admin.id
    })
    first_admin.groups << group
    user_with_multiple_groups.groups << group
  end
end

first_group = Group.find_by(name: 'First Admin Group 0')
second_admin.groups << first_group
users.each { |user| user.groups << first_group }

3.times do |n|
  unless Group.exists?(name: "Second Admin Group #{n}")
    group = Group.create!({
      name: "Second Admin Group #{n}",
      admin_id: second_admin.id
    })
    second_admin.groups << group
    user_with_multiple_groups.groups << group
  end
end

10.times do |n|
  unless Talk.exists?(title: "Talk Title #{n}")
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
end

10.times do |n|
  unless Talk.exists?(title: "トークテーマ #{n}")
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
end

20.times do |n|
  unless Comment.exists?(description: "これはコメントです コメントナンバーは#{n}です")
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
end
