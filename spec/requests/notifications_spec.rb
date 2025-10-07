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
      get group_talks_url(talk.group)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    it 'updates read column and redirect to notifiable link' do
      comment = create(:comment, talk:)
      notification = create(:comment_notification, user:, notifiable: comment)
      expect(notification.read).to be false
      patch notification_path(notification)
      notification.reload
      expect(notification.read).to be true

       expect(response).to redirect_to(notification.link_path)
    end
  end
end
