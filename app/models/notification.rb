class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  DASHBOARD_LIMIT = 3

  def link_title
    case notifiable
    when Comment
      "#{notifiable.talk.title}に#{notifiable.user.nickname}よりコメントがありました（#{I18n.l notifiable.created_at}）"
    else
      '新しい通知があります'
    end
  end

  def link_path
    case notifiable
    when Comment
      talk = notifiable.talk
      group = talk.group
      Rails.application.routes.url_helpers.group_talk_path(group, talk)
    else
      Rails.application.routes.url_helpers.dashboard_path
    end
  end
end
