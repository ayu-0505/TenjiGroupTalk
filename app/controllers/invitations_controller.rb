class InvitationsController < ApplicationController
  skip_before_action :authenticate, only: :create

  # POST /invitations or /invitations.json
  def create
    group = current_user.groups.find(params[:group_id])
    invitation = current_user.invitations.build(group:)

    if invitation.save
      redirect_to group_path(group), notice: '招待が作成されました'
    else
      render group_path(group), status: :unprocessable_entity
    end
  end
end
