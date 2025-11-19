require 'rails_helper'

RSpec.describe '/groups', type: :request do
  let(:group) { create(:group) }
  let(:user) { create(:user) }
  let(:non_member_user) { create(:user) }

  before do
    create(:membership, user:, group:)
  end

  describe 'GET /index' do
    before do
      sign_in user
    end

    it 'renders a successful response' do
      get groups_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    context 'when member user accesses' do
      before do
        sign_in user
      end

      it 'renders a successful response' do
        get group_url(group)
        expect(response).to be_successful
      end
    end

    context 'when a non-member user accesses' do
      before do
        sign_in(non_member_user)
        get dashboard_path
      end

      it 'returns a 404 status' do
        get group_url(group)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /new' do
    before do
      sign_in user
    end

    it 'renders a successful response' do
      get new_group_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    context 'when member user accesses' do
      before do
        sign_in user
      end

      it 'renders a successful response' do
        get edit_group_url(group)
        expect(response).to be_successful
      end
    end

    context 'when a non-member user accesses' do
      before do
        sign_in(non_member_user)
        get dashboard_path
      end

      it 'returns a 404 status' do
        get edit_group_url(group)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /create' do
    before do
      sign_in user
    end

    context 'with valid parameters' do
      let(:valid_attributes) { attributes_for(:group, name: 'Valid Group Name') }

      it 'creates a new Group' do
        expect {
          post groups_url, params: { group: valid_attributes }
        }.to change(Group, :count).by(1)
      end

      it 'redirects to the created group' do
        post groups_url, params: { group: valid_attributes }
        expect(response).to redirect_to(group_url(Group.last))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { attributes_for(:group, name: "#{'a' * 50} Long Name group") }

      it 'does not create a new Group' do
        expect {
          post groups_url, params: { group: invalid_attributes }
        }.not_to change(Group, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post groups_url, params: { group: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /groups/:id' do
    let(:new_attributes) { attributes_for(:group, name: 'New Group Name') }

    context 'when member user accesses' do
      before do
        sign_in user
      end

      it 'updates the group with valid parameters' do
        patch group_url(group), params: { group: new_attributes }

        expect(group.reload.name).to eq 'New Group Name'
        expect(response).to redirect_to(group_path(group))
      end
    end

    context 'when a non-member user accesses' do
      before do
        sign_in(non_member_user)
        get dashboard_path
      end

      it 'does not update the group and returns a 404 status' do
        expect do
          patch group_url(group), params: { group: new_attributes }
        end.not_to change { group.reload.name }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /groups/:id' do
    context 'when member user accesses' do
      before do
        sign_in(user)
      end

      it 'deletes the group' do
        expect do
          delete group_url(group)
        end.to change(Group, :count).by(-1)

        expect(response).to redirect_to(groups_path)
      end
    end

    context 'when a non-member user accesses' do
      before do
        sign_in(non_member_user)
        get dashboard_path
      end

      it 'does not delete the group and returns a 404 status' do
        expect do
          delete group_url(group)
        end.not_to change(Group, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
