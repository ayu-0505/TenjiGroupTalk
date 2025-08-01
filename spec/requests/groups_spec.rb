require 'rails_helper'

RSpec.describe "/groups", type: :request do
  let(:group) { create(:group) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:non_member_user) { create(:user) }

  before do
    create(:membership, user: user, group: group)
    create(:membership, user: user2, group: group)
  end

  describe 'PATCH /groups/:id, #update' do
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

      it 'does not update the group and redirects to root_path' do
        expect do
          patch group_url(group), params: { group: new_attributes }
        end.not_to change { group.reload.name }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe 'DELETE /groups/:id, #destroy' do
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

      it 'does not delete the group and redirects to root_path' do
        expect do
          delete group_url(group)
        end.not_to change(Group, :count)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  # TODO: requestのテストを整理すること
  # describe "GET /index" do
  #   it "renders a successful response" do
  #     Group.create! valid_attributes
  #     get groups_url
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /show" do
  #   it "renders a successful response" do
  #     group = Group.create! valid_attributes
  #     get group_url(group)
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /new" do
  #   it "renders a successful response" do
  #     get new_group_url
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /edit" do
  #   it "renders a successful response" do
  #     group = Group.create! valid_attributes
  #     get edit_group_url(group)
  #     expect(response).to be_successful
  #   end
  # end

  # describe "POST /create" do
  #   context "with valid parameters" do
  #     it "creates a new Group" do
  #       expect {
  #         post groups_url, params: { group: valid_attributes }
  #       }.to change(Group, :count).by(1)
  #     end

  #     it "redirects to the created group" do
  #       post groups_url, params: { group: valid_attributes }
  #       expect(response).to redirect_to(group_url(Group.last))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "does not create a new Group" do
  #       expect {
  #         post groups_url, params: { group: invalid_attributes }
  #       }.not_to change(Group, :count)
  #     end

  #     it "renders a response with 422 status (i.e. to display the 'new' template)" do
  #       post groups_url, params: { group: invalid_attributes }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  # end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested group" do
  #       group = Group.create! valid_attributes
  #       patch group_url(group), params: { group: new_attributes }
  #       group.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "redirects to the group" do
  #       group = Group.create! valid_attributes
  #       patch group_url(group), params: { group: new_attributes }
  #       group.reload
  #       expect(response).to redirect_to(group_url(group))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a response with 422 status (i.e. to display the 'edit' template)" do
  #       group = Group.create! valid_attributes
  #       patch group_url(group), params: { group: invalid_attributes }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  # end

  # describe "DELETE /destroy" do
  #   it "destroys the requested group" do
  #     group = Group.create! valid_attributes
  #     expect {
  #       delete group_url(group)
  #     }.to change(Group, :count).by(-1)
  #   end

  #   it "redirects to the groups list" do
  #     group = Group.create! valid_attributes
  #     delete group_url(group)
  #     expect(response).to redirect_to(groups_url)
  #   end
  # end
end
