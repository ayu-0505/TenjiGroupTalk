class HomeController < ApplicationController
  skip_before_action :authenticate, only: %i[index welcome]

  def index
    redirect_to dashboard_path if current_user.present?
  end

  def welcome
    @invitation_token = params[:invitation_token]
    invitation = Invitation.find_by(token: @invitation_token)

    if invitation.nil? || invitation.expired?
      redirect_to root_path, alert: '無効な招待リンク、または招待リンクの期限切れです'
      return
    end

    if current_user.present?
      group = invitation.group

      if current_user.groups.include?(group)
        redirect_to dashboard_path, notice: 'このグループにはすでに参加済みです'
      else
        current_user.groups << group
        redirect_to group_talks_path(group), notice: "#{invitation.group.name}に参加しました！"
      end
    end
  end
end
