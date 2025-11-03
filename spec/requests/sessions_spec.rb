require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST /create' do
    shared_context 'when there is a valid token' do
      let(:user) { create(:user) }
      let(:group) { create(:group, admin: user) }
      let(:invitation) { create(:invitation, user:, group:) }

      before do
        user.groups << group
        Rails.application.env_config['omniauth.params'] ||= {}
        Rails.application.env_config['omniauth.params']['invitation_token'] = invitation.token
      end
    end

    context 'when logging in as a new user' do
      let(:new_user) { build(:user, email: 'new@example.com') }

      before do
        Rails.application.env_config['omniauth.auth'] = google_mock(new_user)
      end

      context 'when there is no token' do
        it 'creates a new user, sets the user_id session, and redirects to the dashboard' do
          expect do
            get '/auth/:provider/callback'
          end.to change(User, :count).by(1)
          new_created_user = User.last
          expect(session[:user_id]).to eq new_created_user.id
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(dashboard_path)
        end
      end

      context 'when there is a valid token' do
        include_context 'when there is a valid token'

        it 'creates a new user, sets the user_id session, adds the user to the group and redirects to the dashboard' do
          expect do
            get '/auth/:provider/callback'
          end.to change(User, :count).by(1)
          new_created_user = User.last
          expect(session[:user_id]).to eq new_created_user.id
          expect(new_created_user.groups.include?(group)).to be true
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(dashboard_path)
        end
      end

      context 'when there is an invalid token' do
        before do
          Rails.application.env_config['omniauth.params'] ||= {}
          Rails.application.env_config['omniauth.params']['invitation_token'] = 'invalid token'
        end

        it 'redirects to the root' do
          get '/auth/:provider/callback'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when there is an expired token' do
        let(:user) { create(:user) }
        let(:group) { create(:group, admin: user) }
        let(:expired_invitation) { create(:invitation, user:, group:, expires_at: Time.current.yesterday) }

        before do
          user.groups << group
          Rails.application.env_config['omniauth.params'] ||= {}
          Rails.application.env_config['omniauth.params']['invitation_token'] = expired_invitation.token
        end

        it 'redirects to the root' do
          get '/auth/:provider/callback'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when logging in as an existing user' do
      let(:existing_user) { create(:user) }

      before do
        Rails.application.env_config['omniauth.auth'] = google_mock(existing_user)
      end

      context 'when there is no token' do
        it 'sets the user_id session and redirects to the dashboard' do
          get '/auth/:provider/callback'

          expect(session[:user_id]).to eq existing_user.id
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(dashboard_path)
        end
      end

      context 'when there is a valid token and the user is not a member of the group' do
        include_context 'when there is a valid token'

        it 'sets the user_id session, adds the user to the group and redirects to the dashboard' do
          get '/auth/:provider/callback'

          expect(session[:user_id]).to eq existing_user.id
          expect(existing_user.groups.include?(group)).to be true
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(dashboard_path)
        end
      end

      context 'when there is a valid token and the user is already a member of the group' do
        include_context 'when there is a valid token'

        before do
          existing_user.groups << group
        end

        it 'sets the user_id session and redirects to the dashboard' do
          expect(existing_user.groups.include?(group)).to be true
          get '/auth/:provider/callback'

          expect(session[:user_id]).to eq existing_user.id
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(dashboard_path)
        end
      end

      context 'when there is an invalid token' do
        before do
          Rails.application.env_config['omniauth.params'] ||= {}
          Rails.application.env_config['omniauth.params']['invitation_token'] = 'invalid token'
        end

        it 'redirects to the root' do
          get '/auth/:provider/callback'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when there is an expired token' do
        let(:user) { create(:user) }
        let(:group) { create(:group, admin: user) }
        let(:expired_invitation) { create(:invitation, user:, group:, expires_at: Time.current.yesterday) }

        before do
          user.groups << group
          Rails.application.env_config['omniauth.params'] ||= {}
          Rails.application.env_config['omniauth.params']['invitation_token'] = expired_invitation.token
        end

        it 'redirects to the root' do
          get '/auth/:provider/callback'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when user info is invalid' do
      it 'redirects to root path' do
        Rails.application.env_config['omniauth.auth'] = false
        get '/auth/:provider/callback'
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the session and redirects to the root' do
      user = create(:user)
      sign_in(user)

      delete session_path(user.id)
      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /auth_failure' do
    it 'deletes the session and redirects to the root' do
      get auth_failure_path
      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end
end
