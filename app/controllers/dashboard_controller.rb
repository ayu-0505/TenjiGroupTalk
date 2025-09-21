class DashboardController < ApplicationController
  def index
    @groups = current_user.groups.preload(:talks)
    @unread_notifications = current_user.notifications.unread
  end
end
