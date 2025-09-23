class SubscriptionsController < ApplicationController
  before_action :set_talk_and_group

  def create
    subscription = current_user.subscriptions.build(talk: @talk)
    subscription.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to group_talk_path(@group, @talk) }
    end
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to group_talk_path(@group, @talk), status: :see_other }
    end
  end

  private
  def set_talk_and_group
    @talk = Talk.find(params[:talk_id])
    @group = @talk.group
  end
end
