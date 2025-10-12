class Api::SubscriptionsController < ApplicationController
  def create
    talk = current_user.talks.find(params[:talk_id])
    subscription = current_user.subscriptions.build(talk: talk)
    if subscription.save
      render json: { notice: '通知登録しました', id: subscription.id }, status: :ok
    else
      # save失敗時の処理
    end
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy
    render json: { notice: '通知登録を解除しました' }, status: :ok
  end
end
