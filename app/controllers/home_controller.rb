class HomeController < ApplicationController
  skip_before_action :check_logged_in, only: :index

  def index
    redirect_to dashboard_path if current_user.present?
  end
end
