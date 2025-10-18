require 'rails_helper'

RSpec.describe '/notifications/allmarks', type: :request do
  let(:user) { create(:user) }
  let(:talk) { create(:talk) }
  let(:comments) { create_list(:comment, 5, talk:) }

  before do
    comments.each do |comment|
      create(:notification, user:, comment:)
    end
    user.groups << talk.group
    sign_in(user)
  end

  describe 'POST /create' do
    it 'updates all unread notifications and' do
      expect(user.notifications.all? { |notification| notification.read == false }).to be true
      post allmarks_path
      expect(user.notifications.reload.all? { |notification| notification.read == true }).to be true
    end

    it 'redirects to the last requested path (dashboard_path)' do
      get dashboard_path
      post allmarks_path
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
