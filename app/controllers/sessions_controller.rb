class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[create dev_login]

  def create
    user = User.find_or_initialize_from_auth_hash!(request.env['omniauth.auth'])
    token = request.env.dig('omniauth.params', 'invitation_token')

    if token.present?
      invitation = Invitation.find_by(token:)
      if invitation.nil? || invitation.expired?
        redirect_to root_path, alert: '無効な招待リンク、または期限が切れています', status: :see_other
        return
      end
    end

    ActiveRecord::Base.transaction do
      user.save!
      if token.present?
        user.groups << invitation.group unless user.groups.exists?(invitation.group.id)
      end
    end

    reset_session
    session[:user_id] = user.id
    redirect_to dashboard_path, notice: 'ログインしました', status: :see_other

  rescue => e
    Rails.logger.error("Session#create failed: #{e.message}")
    redirect_to root_path, alert: 'ログインに失敗しました', status: :see_other
  end

  def destroy
    reset_session
    redirect_to root_path, status: :see_other
  end

  def auth_failure
    reset_session
    redirect_to root_url, alert: 'Googleログインがキャンセルされました', status: :see_other
  end

  def dev_login
    return if params[:uid] == 'deleted_user'

    user = User.find_by(uid: params[:uid])
    if user
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, notice: "#{user.name} としてログインしました"
    else
      reset_session
      redirect_to root_path, alert: "uid=#{params[:uid]} のユーザーが見つかりません"
    end
  end
end
