class Api::SubscriptionsController < ApplicationController
  def create
    talk = Talk.find(params[:talk_id])
    subscription = current_user.subscriptions.build(talk: talk)
    if subscription.save
      flash.now[:notice] = '通知登録しました'
      html = render_to_string partial: 'layouts/flash'
      render json: { id: subscription.id, html: }, status: :ok
    else
      flash.now[:alert] = '通信中にエラーが発生しました'
      html = render_to_string partial: 'layouts/flash'
      render json: { html: }, status: :unprocessable_entity
    end
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    if subscription.destroy
      flash.now[:notice] = '通知登録を解除しました'
      html = render_to_string partial: 'layouts/flash'
      render json: { html: }, status: :ok
    else
      flash.now[:alert] = '通信中にエラーが発生しました'
      html = render_to_string partial: 'layouts/flash'
      render json: { html: }, status: :unprocessable_entity
    end
  end
end
