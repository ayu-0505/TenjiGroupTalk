require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  describe 'PATCH /update' do
    it 'updates read column and redirect to notifiable link' do
      user = create(:user)
      talk = create(:talk)
      user.groups << talk.group
      comment = create(:comment, talk:)
      notification = create(:comment_notification, user:, notifiable: comment)
      sign_in(user)

      expect(notification.read).to be false
      patch notification_path(notification)
      notification.reload
      expect(notification.read).to be true

       expect(response).to redirect_to(notification.link_path)
    end
  end
end
