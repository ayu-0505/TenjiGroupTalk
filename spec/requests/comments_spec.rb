require 'rails_helper'

RSpec.describe '/comments', type: :request do
  let(:user) { create(:user) }
  let(:non_owner_user) { create(:user) }
  let!(:group) { create(:group) }
  let!(:talk) { create(:talk, group: group, user: user) }
  let!(:comment) { create(:comment, talk: talk, user: user) }

  let(:valid_attributes) { {
    description: 'this text is valid.', original_text: 'てんじ'
  } }

  let(:invalid_attributes) { {
    description: '', original_text: ''
  } }

  before do
    group.users << user
    group.users << non_owner_user
  end

  shared_examples 'returns 404 not found' do
    it 'returns 404 not found' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /edit' do
    context 'when user is owner' do
      before { sign_in(user) }

      it 'renders a successful response' do
        get edit_talk_comment_url(talk, comment)
        expect(response).to be_successful
      end
    end

    context 'when user is a not owner' do
      subject { get edit_talk_comment_url(talk, comment) }

      before { sign_in(non_owner_user) }

      it_behaves_like 'returns 404 not found'
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before { sign_in(user) }

      it 'creates a new comment' do
        expect {
          post talk_comments_path(talk), params: { comment_braille_form: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it 'redirects to the talk' do
        post talk_comments_path(talk), params: { comment_braille_form: valid_attributes }
        expect(response).to redirect_to(group_talk_url(group, talk))
      end
    end

    context 'with invalid parameters' do
      before { sign_in(user) }

      it 'does not create a new Talk' do
        expect {
          post talk_comments_path(talk), params: { comment_braille_form: invalid_attributes }
        }.not_to change(Talk, :count)
      end

      it 'redirects to the talk with error messages' do
        post talk_comments_path(talk), params: { comment_braille_form: invalid_attributes }
        expect(response).to redirect_to(group_talk_url(group, talk))
        expect(flash[:error]).to be_present
      end
    end

    context 'when user is a not group member' do
      subject { post talk_comments_path(talk), params: { comment_braille_form: valid_attributes } }

      before do
       non_member_user = create(:user)
       sign_in(non_member_user)
      end

      it_behaves_like 'returns 404 not found'
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { {
      description: 'New Comment', original_text: 'こんにちわ　てんじ'
    } }

    context 'when user is owner with valid parameters' do
      before { sign_in(user) }

      it 'updates the requested comment and redirects to the talk' do
        patch talk_comment_url(talk, comment), params: { comment_braille_form: new_attributes }
        comment.reload
        expect(comment.description).to eq 'New Comment'
        expect(response).to redirect_to(group_talk_path(group, talk))
      end
    end

    context 'when user is owner with invalid parameters' do
      before { sign_in(user) }

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch talk_comment_url(talk, comment), params: { comment_braille_form: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is a not owner' do
      subject { patch talk_comment_url(talk, comment), params: { comment_braille_form: new_attributes } }

      before { sign_in(non_owner_user) }

      it_behaves_like 'returns 404 not found'
    end
  end

  describe 'DELETE /destroy' do
    context 'when user is owner' do
      before { sign_in(user) }

      it 'destroys the requested commentand redirects to the talk' do
        expect {
          delete talk_comment_url(talk, comment), as: :turbo_stream
        }.to change(Comment, :count).by(-1)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        expect(response.body).to include('turbo-stream')
      end
    end

    context 'when user is not owner' do
      subject { get edit_talk_comment_url(comment.talk, comment) }

      before { sign_in(non_owner_user) }

      it_behaves_like 'returns 404 not found'
    end
  end
end
