class Notifications::AllmarksController < ApplicationController
  def create
    unread_notifications = current_user.notifications.unread
    unread_notifications.update_all(read: true)
    redirect_back_or_to dashboard_path, status: :see_other, notice: '全て既読にしました'
  end
end
