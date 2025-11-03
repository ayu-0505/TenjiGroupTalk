class DashboardController < ApplicationController
  def index
    @groups = current_user.groups.order(created_at: :desc)
    @unread_notifications = current_user.notifications.unread.preload(comment: [ :talk, :user ]).order(created_at: :desc)
  end
end
