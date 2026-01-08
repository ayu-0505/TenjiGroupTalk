class Api::SubscriptionsController < ApplicationController
  def create
    talk = Talk.joins(:group).where(group: { id: current_user.group_ids }).find(params.expect(:talk_id))

    subscription = current_user.subscriptions.build(talk:)
    subscription.save!
    flash.now[:notice] = '通知登録しました'
    html = render_to_string partial: 'layouts/flash'
    render json: { id: subscription.id, html: }, status: :ok
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy!
    flash.now[:notice] = '通知登録を解除しました'
    html = render_to_string partial: 'layouts/flash'
    render json: { html: }, status: :ok
  end
end
