class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  scope :unread, -> { where(read: false) }

  DASHBOARD_LIMIT = 3

  def link_title
    "#{comment.talk.title}に#{comment.user.nickname}よりコメントがありました（#{I18n.l comment.created_at}）"
  end

  def link_path
    talk = comment.talk
    group = talk.group
    Rails.application.routes.url_helpers.group_talk_path(group, talk)
  end
end
