require 'rails_helper'

RSpec.describe 'Current_users', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_current_user_path
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { attributes_for(:user, nickname: 'New Nickname') }

    it 'updates the group with valid parameters' do
      patch current_user_path, params: { user: new_attributes }

      expect(user.reload.nickname).to eq 'New Nickname'
      expect(response).to redirect_to(user_path(user))
    end
  end

  describe 'DELETE /destroy' do
    it 'updates deleted_at, name, email, uid and image (soft delete)' do
      delete current_user_path
      expect(user.reload).to have_attributes(
        name: 'deleted_name',
        image: ActionController::Base.helpers.asset_path('test_user_icon.png')
      )
      expect(user.email).to start_with('dummy_email_')
      expect(user.uid).to start_with('dummy_uid_')
    end

    it 'redirects to the root' do
      delete current_user_path
      expect(response).to redirect_to(root_path)
    end
  end
end
