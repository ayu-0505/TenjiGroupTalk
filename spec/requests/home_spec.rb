require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  let(:user) { create(:user) }

  describe 'GET /index' do
    context 'when user is not logged in' do
      it 'renders a successful response' do
        get root_path
        expect(response).to be_successful
      end
    end

    context 'when user is logged in' do
      it 'redirects to dashboard' do
        sign_in(user)
        get root_path
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe 'GET /welcome' do
    context 'when the user is not logged in' do
      context 'when there is a valid token' do
        it 'renders a successful response' do
          invitation = create(:invitation, user:)
          get welcome_path, params: { invitation_token: invitation.token }
          expect(response).to be_successful
          expect(response.body).to include(
            "/auth/google_oauth2/?invitation_token=#{invitation.token}"
          )
        end
      end

      context 'when there is an invalid token' do
        it 'redirects to the root' do
          get welcome_path, params: { invitation_token: 'invalid_token' }
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when there is an expired token' do
        it 'redirects to the root' do
          expired_invitation = create(:invitation, user:, expires_at: Time.current.yesterday)
          get welcome_path, params: { invitation_token: expired_invitation.token }
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is logged in' do
      let(:logged_user) { create(:user) }

      before do
        sign_in(logged_user)
      end

      context 'when the user is not a member of the group' do
        it 'adds the user to the group and redirects to the talks of the group' do
          invitation = create(:invitation, user:)
          get welcome_path, params: { invitation_token: invitation.token }
          expect(logged_user.groups.include?(invitation.group)).to be true
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(group_talks_path(invitation.group))
        end
      end

      context 'when the user is already a member of the group' do
        it 'redirects to the dashboard' do
          invitation = create(:invitation, user:)
          logged_user.groups << invitation.group
          get welcome_path, params: { invitation_token: invitation.token }
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(dashboard_path)
        end
      end
    end
  end
end
