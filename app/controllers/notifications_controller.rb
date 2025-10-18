class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)
    redirect_to notification.link_path
  end
end
