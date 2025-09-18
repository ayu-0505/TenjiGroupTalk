# frozen_string_literal: true

class MembershipsController < ApplicationController
  def destroy
    group = current_user.groups.find(params[:group_id])
    membership = current_user.memberships.find(params[:id])

    if current_user == group.admin
      return redirect_to group_path(group), status: :see_other, alert: '管理者はグループを抜けられません。グループ削除を行なってください。'
    end

    membership = current_user.memberships.find_by!(group_id: params[:group_id])
    membership.destroy!

    redirect_to dashboard_path, status: :see_other, notice: "#{group.name}から抜けました。もういちど参加する場合はメンバーに招待URLを発行してもらってください。"
  end
end
