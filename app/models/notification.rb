class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :user_id, uniqueness: { scope: :comment_id }

  scope :unread, -> { where(read: false) }

  DASHBOARD_LIMIT = 3

  def link_title
    "#{comment.talk.title}に#{comment.user.display_name}よりコメントがありました\n（#{I18n.l comment.created_at}）"
  end
end
