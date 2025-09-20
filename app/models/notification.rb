class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

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
end
