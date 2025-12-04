class DashboardController < ApplicationController
  def index
    @group = current_user.groups.order(created_at: :desc).first
  end
end
