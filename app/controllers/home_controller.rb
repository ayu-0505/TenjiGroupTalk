class HomeController < ApplicationController
  skip_before_action :authenticate, only: :index

  def index
    redirect_to dashboard_path if current_user.present?
  end
end
