class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.preload(comment: [ :talk, :user ]).order(created_at: :desc).page(params[:page])
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)
    talk = notification.comment.talk
    group = talk.group
    redirect_to group_talk_path(group, talk)
  end
end
