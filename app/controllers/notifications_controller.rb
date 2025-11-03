class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.preload(comment: [ :talk, :user ]).order(created_at: :desc).page(params[:page])
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)
    redirect_to notification.link_path
  end
end
