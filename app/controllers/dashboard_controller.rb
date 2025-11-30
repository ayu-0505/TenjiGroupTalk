class DashboardController < ApplicationController
  def index
    @groups = current_user.groups.order(created_at: :desc)
  end
end
