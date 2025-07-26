# frozen_string_literal: true

class MembershipsController < ApplicationController
  # TODO:招待制のためURLを作成するようになる
  def create
  end

  def destroy
    group = current_user.groups.find(params[:group_id])
    membership = current_user.memberships.find(params[:id])

    if group.member_count == 1 && current_user.member_of?(group)
      return redirect_to group_path(group), status: :see_other, alert: '最後のメンバーはグループを抜けられません。グループ削除を行なってください。'
    end

    membership = current_user.memberships.find_by!(group_id: params[:group_id])
    membership.destroy!

    redirect_to dashboard_path, status: :see_other, notice: 'xxxグループから抜けました。もういちど参加する場合はメンバーに招待URLを発行してもらってください。'
  end
end
