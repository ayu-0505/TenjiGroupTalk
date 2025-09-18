require 'rails_helper'


RSpec.describe '/invitations', type: :request do
  let(:user) { create(:user) }
  let(:group) { create(:group, admin: user) }

  describe 'POST /create' do
    before do
      user.groups << group
      sign_in(user)
    end

    it 'creates a new Invitation' do
      expect {
        post group_invitations_path(group)
      }.to change(Invitation, :count).by(1)
    end

    it 'redirects to the created invitation' do
      post group_invitations_path(group)
      expect(response).to redirect_to(group_path(group))
    end
  end
end
