require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  let(:user) { create(:user) }
  let(:talk) { create(:talk) }

  before do
    user.groups << talk.group
    sign_in(user)
  end

  describe 'POST /create' do
    it 'creates a subscription' do
      expect {
        post api_subscriptions_path(talk_id: talk)
      }.to change(Subscription, :count).by(1)
      subscription = Subscription.last
      expect(user.subscriptions.include?(subscription)).to be true
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the subscription' do
      subscription = user.subscriptions.create(talk:)
      expect {
        delete api_subscription_path(subscription)
      }.to change(Subscription, :count).by(-1)
      expect(user.subscriptions.include?(subscription)).to be false
    end
  end
end
