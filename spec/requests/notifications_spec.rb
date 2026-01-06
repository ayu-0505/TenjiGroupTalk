require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:user) { create(:user) }
  let(:talk) { create(:talk) }

  before do
    user.groups << talk.group
    sign_in(user)
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get notifications_path
      expect(response).to be_successful
    end

    it 'renders the notification content' do
      comment = create(:comment, talk:)
      notification = create(:notification, user:, comment:)
      get notifications_path
      expect(response.body).to include(notification.comment.talk.title)
    end
  end

  describe 'PATCH /update' do
    it 'updates read column and redirect to comment link' do
      comment = create(:comment, talk:)
      notification = create(:notification, user:, comment:)
      expect(notification.read).to be false
      patch notification_path(notification)
      notification.reload
      expect(notification.read).to be true
      expect(response).to redirect_to("/groups/#{talk.group.id}/talks/#{talk.id}")
    end
  end
end
