require 'rails_helper'

RSpec.describe '/talks', type: :request do
  let(:owner_user) { create(:user) }
  let(:member_user) { create(:user) }
  let(:non_member_user) { create(:user) }
  let!(:group) { create(:group) }
  let!(:talk) { create(:talk, group: group, user: owner_user) }

  let(:valid_attributes) {
    attributes_for(:talk, title: 'Valid Title', description: 'this text is valid.')
  }
  let(:invalid_attributes) {
    attributes_for(:talk, title: "#{ 'test'*100 } Invalid Title", description: '')
  }

  before do
    group.users << member_user
    group.users << owner_user
  end

  shared_examples 'returns 404 not found' do
    it 'returns 404 not found' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /index' do
    context 'when user is a group member' do
      before { sign_in(member_user) }

      it 'renders a successful response' do
        get group_talks_url(talk.group)
        expect(response).to be_successful
      end
    end

    context 'when user is non member' do
      subject { get group_talks_path(group) }

      before { sign_in(non_member_user) }

      it_behaves_like 'returns 404 not found'
    end
  end


  describe 'GET /show' do
    context 'when user is a group member' do
      before { sign_in(member_user) }

      it 'renders a successful response' do
        get group_talk_url(talk.group, talk)
        expect(response).to be_successful
      end
    end

    context 'when user is non member' do
      subject { get group_talk_url(talk.group, talk) }

      before { sign_in(non_member_user) }

      it_behaves_like 'returns 404 not found'
    end
  end


  describe 'GET /new' do
    context 'when user is a group member' do
      before { sign_in(member_user) }

      it 'renders a successful response' do
        get new_group_talk_url(talk.group)
        expect(response).to be_successful
      end
    end

    context 'when user is non member' do
      subject { get new_group_talk_url(talk.group) }

      before { sign_in(non_member_user) }

      it_behaves_like 'returns 404 not found'
    end
  end

  describe 'GET /edit' do
    context 'when user is owner' do
    before { sign_in(owner_user) }

      it 'renders a successful response' do
        get edit_group_talk_url(talk.group, talk)
        expect(response).to be_successful
      end
    end

    context 'when user is a group member but not owner' do
      before do
        sign_in(member_user)
        get dashboard_path
      end

      it 'redirects to the last requested path (dashboard_path)' do
        get edit_group_talk_url(talk.group, talk)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when user is non member' do
      subject { get edit_group_talk_url(talk.group, talk) }

      before { sign_in(non_member_user) }

      it_behaves_like 'returns 404 not found'
    end
  end

  describe 'POST /create' do
    context 'when user is a group member with valid parameters' do
      before { sign_in(member_user) }

      it 'creates a new Talk' do
        expect {
          post group_talks_url(talk.group), params: { talk: valid_attributes }
        }.to change(Talk, :count).by(1)
      end

      it 'redirects to the created talk' do
        post group_talks_url(talk.group), params: { talk: valid_attributes }
        expect(response).to redirect_to(group_talk_url(talk.group, Talk.last))
      end
    end

    context 'when user is a group member with invalid parameters' do
      before { sign_in(member_user) }

      it 'does not create a new Talk' do
        expect {
          post group_talks_url(talk.group), params: { talk: invalid_attributes }
        }.not_to change(Talk, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post group_talks_url(talk.group), params: { talk: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is non member' do
      subject { post group_talks_url(talk.group), params: { talk: valid_attributes } }

      before { sign_in(non_member_user) }

      it_behaves_like 'returns 404 not found'
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) {
      attributes_for(:talk, title: 'New Title', description: 'New Text')
    }

    context 'when user is owner with valid parameters' do
      before { sign_in(owner_user) }

      it 'updates the requested talk and redirects to the talk' do
        patch group_talk_url(talk.group, talk), params: { talk: new_attributes }
        talk.reload
        expect(talk.title).to eq 'New Title'
        expect(talk.description).to eq 'New Text'
        expect(response).to redirect_to(group_talk_path(talk.group, talk))
      end
    end

    context 'when user is owner with invalid parameters' do
      before { sign_in(owner_user) }

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch group_talk_url(talk.group, talk), params: { talk: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is a group member but not owner' do
      before do
        sign_in(member_user)
        get dashboard_path
      end

      it 'does not update the talk and redirects to the last requested path (dashboard_path)' do
        patch group_talk_url(talk.group, talk), params: { talk: new_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when user is non member' do
      subject { patch group_talk_url(talk.group, talk), params: { talk: new_attributes } }

      before { sign_in(non_member_user) }

      it_behaves_like 'returns 404 not found'
    end
  end

  describe 'DELETE /destroy' do
    context 'when user is owner' do
      before { sign_in(owner_user) }

      it 'destroys the requested talk and redirects to the talks list' do
        group = talk.group
        expect {
          delete group_talk_url(talk.group, talk)
        }.to change(Talk, :count).by(-1)
        expect(response).to redirect_to(group_talks_url(group))
      end
    end

    context 'when user is a group member but not owner' do
      before do
        sign_in(member_user)
        get dashboard_path
      end

      it 'does not delete the talk and redirects to the last requested path (dashboard_path)' do
        expect do
          delete group_talk_url(talk.group, talk)
        end.not_to change(Talk, :count)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when user is non member' do
      subject { delete group_talk_url(talk.group, talk) }

      before { sign_in(non_member_user) }

      it_behaves_like 'returns 404 not found'
    end
  end
end
