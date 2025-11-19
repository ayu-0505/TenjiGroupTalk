require 'rails_helper'

RSpec.describe TalkSubscriber, type: :model do
  let(:user) { create(:user) }
  let(:talk) { create(:talk) }

  it 'creates a subscription for the talk creator' do
    expect {
      ActiveSupport::Notifications.instrument('talk.create', user:, talk:)
    }.to change(Subscription, :count).by(1)

    subscription = Subscription.last
    expect(subscription.user).to eq user
    expect(subscription.talk).to eq talk
  end
end
