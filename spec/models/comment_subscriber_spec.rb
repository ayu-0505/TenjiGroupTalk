require 'rails_helper'

RSpec.describe CommentSubscriber, type: :model do
  let(:user) { create(:user) }
  let(:talk) { create(:talk) }

  it 'creates a subscription for the comment creator' do
    expect {
      ActiveSupport::Notifications.instrument('comment.create', user: user, talk: talk, comment: nil)
    }.to change(Subscription, :count).by(1)

    subscription = Subscription.last
    expect(subscription.user).to eq user
    expect(subscription.talk).to eq talk
  end
end
