class SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    user = User.find_or_initialize_from_auth_hash!(request.env['omniauth.auth'])
    token = request.env.dig('omniauth.params', 'invitation_token')

    if token.present?
      invitation = Invitation.find_by(token:)
      if invitation.nil? || invitation.expired?
        redirect_to root_path, alert: '無効な招待リンク、または期限が切れています'
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
    redirect_to dashboard_path, notice: 'ログインしました'

  rescue => e
    Rails.logger.error("Session#create failed: #{e.message}")
    redirect_to root_path, alert: 'ログインに失敗しました'
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
