require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
   it 'renders a successful response' do
      get edit_user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { attributes_for(:user, nickname: 'New Nickname') }

    it 'updates the group with valid parameters' do
      patch user_path(user), params: { user: new_attributes }

      expect(user.reload.nickname).to eq 'New Nickname'
      expect(response).to redirect_to(user_path(user))
    end
  end

  describe 'DELETE /destroy' do
    it 'updates deleted_at, name, email, uid and image (soft delete)' do
      delete user_path(user)
      expect(user.reload).to have_attributes(
        name: 'deleted_name',
        image: ActionController::Base.helpers.asset_path('test_user_icon.png')
      )
      expect(user.email).to start_with('dummy_email_')
      expect(user.uid).to start_with('dummy_uid_')
    end

    it 'redirects to the root' do
      delete user_path(user)
      expect(response).to redirect_to(root_path)
    end
  end
end
