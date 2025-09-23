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

  # describe "GET /show" do
  #   it "renders a successful response" do
  #     user = User.create! valid_attributes
  #     get user_url(user)
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /edit" do
  #   it "renders a successful response" do
  #     user = User.create! valid_attributes
  #     get edit_user_url(user)
  #     expect(response).to be_successful
  #   end
  # end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested user" do
  #       user = User.create! valid_attributes
  #       patch user_url(user), params: { user: new_attributes }
  #       user.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "redirects to the user" do
  #       user = User.create! valid_attributes
  #       patch user_url(user), params: { user: new_attributes }
  #       user.reload
  #       expect(response).to redirect_to(user_url(user))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a response with 422 status (i.e. to display the 'edit' template)" do
  #       user = User.create! valid_attributes
  #       patch user_url(user), params: { user: invalid_attributes }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  # end

  describe 'DELETE /destroy' do
    it 'updates deleted_at, name, email, uid and image (soft delete)' do
      delete user_path(user)
      expect(user.reload).to have_attributes(
        name: 'deleted_name',
        email: 'deleted_email',
        uid: 'deleted_uid',
        image: 'deleted_image'
      )
    end

    it 'redirects to the root' do
      delete user_path(user)
      expect(response).to redirect_to(root_path)
    end
  end
end
