class Api::SubscriptionsController < ApplicationController
  def create
    talk = current_user.talks.find(params[:talk_id])
    subscription = current_user.subscriptions.build(talk: talk)
    if subscription.save
      flash.now[:notice] = '通知登録しました'
      html = render_to_string partial: 'layouts/flash'
      render json: { id: subscription.id, html: html }, status: :ok
    else
      # save失敗時の処理
    end
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy
    flash.now[:notice] = '通知登録を解除しました'
    html = render_to_string partial: 'layouts/flash'
    render json: { html: html }, status: :ok
  end
end
