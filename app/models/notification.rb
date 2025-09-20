class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  def self.create_notifications_by(commenter, comment)
    subscribers = comment.talk.subscribers - [ commenter ]

    subscribers.each do |subscriber|
      Notification.create(
        user: subscriber,
        notifiable_type: 'Comment',
        notifiable_id: comment.id
      )
    end
  end

  def link_title
    case notifiable
    when Comment
      "#{notifiable.talk.title}に#{notifiable.user.name}よりコメントがありました"
    else
      '新しい通知があります'
    end
  end
end
