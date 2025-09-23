class DashboardController < ApplicationController
  def index
    @groups = current_user.groups.preload(:talks)
  end
end
