class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :authenticate
  helper_method :logged_in?, :current_user

  def authenticate
    return if logged_in?

    redirect_to root_path, alert: 'ログインしてください'
  end

  def logged_in?
    !!current_user
  end

  def current_user
    return unless (user_id = session[:user_id])

    @current_user ||= User.find_by(id: user_id)
  end
end
