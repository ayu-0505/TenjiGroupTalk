require 'rails_helper'

RSpec.describe CommentNotificater, type: :model do
  let(:user) { create(:user) }
  let(:subscriber1) { create(:user) }
  let(:subscriber2) { create(:user) }
  let(:talk) { create(:talk) }
  let(:comment) { create(:comment, user:, talk:) }

  it 'creates notifications for the subscribers' do
    talk.subscribers << subscriber1
    talk.subscribers << subscriber2

    expect {
      ActiveSupport::Notifications.instrument('comment.create', user:, talk:, comment:)
    }.to change(Notification, :count).by(2)
    expect(subscriber1.notifications.last.comment).to eq comment
    expect(subscriber2.notifications.last.comment).to eq comment
  end

  it 'dose not create a notification for the creator' do
    talk.subscribers << user

    expect {
      ActiveSupport::Notifications.instrument('comment.create', user:, talk:, comment:)
    }.not_to change(Notification, :count)
  end
end
