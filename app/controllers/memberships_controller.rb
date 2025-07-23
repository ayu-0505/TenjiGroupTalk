# frozen_string_literal: true

class MembershipsController < ApplicationController
  # TODO:招待制のためURLを作成するようになる
  def create
  end

  def destroy
    membership = current_user.memberships.find_by!(group_id: params[:group_id])
    membership.destroy!

    redirect_to dashboard_path, status: :see_other, notice: 'xxxグループから抜けました。もういちど参加する場合はメンバーに招待URLを発行してもらってください。'
  end
end
