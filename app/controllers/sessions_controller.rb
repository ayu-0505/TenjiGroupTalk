class SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    if (user = User.find_or_create_from_auth_hash!(auth_hash))
      reset_session
      session[:user_id] = user.id
    end
    redirect_to root_path, notice: 'ログインしました'
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
