class ApplicationController < ActionController::Base
  before_action :authenticate, :set_unread_notifications
  helper_method :logged_in?, :current_user

  private

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

  def set_unread_notifications
    @unread_notifications = current_user.notifications.unread.preload(comment: [ :talk, :user ]).order(created_at: :desc)
  end
end
