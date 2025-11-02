require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before do
    sign_in(user)
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
