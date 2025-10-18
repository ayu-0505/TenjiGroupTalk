class DashboardController < ApplicationController
  def index
    @groups = current_user.groups.order(created_at: :desc)
    @unread_notifications = current_user.notifications.unread.order(created_at: :desc)
  end
end
