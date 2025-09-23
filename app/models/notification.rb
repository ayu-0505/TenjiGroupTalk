class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  def link_title
    case notifiable
    when Comment
      "#{notifiable.talk.title}に#{notifiable.user.name}よりコメントがありました"
    else
      '新しい通知があります'
    end
  end
end
