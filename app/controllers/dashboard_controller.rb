class DashboardController < ApplicationController
  before_action :set_selected_group, only: :index

  def index
    @groups = current_user.groups.order(created_at: :desc)
    @group = @selected_group || @groups.first
  end

  private
    def set_selected_group
      group_id = params[:group_id] || session[:dashboard_group_id]
      @selected_group = current_user.groups.find_by(id: group_id)
      session[:dashboard_group_id] = @selected_group&.id
    end
end
