require 'rails_helper'

RSpec.describe 'Memberships', type: :request do
  describe 'DELETE /destroy' do
    context 'when an admin tries to leave the group' do
      it 'does not allow leaving and redirects to the group show page' do
        admin_user = create(:user)
        group = create(:group, admin: admin_user)
        membership = create(:membership, group:, user: admin_user)
        sign_in(admin_user)

        delete group_membership_path(group, membership)
        admin_user.reload
        expect(admin_user.groups.include?(group)).to be true
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(group_path(group))
      end
    end

    context 'when a non-admin user tries to leave the group' do
      it 'allows leaving and redirects to the dashboard' do
        user = create(:user)
        group = create(:group)
        membership = create(:membership, group:, user:)
        sign_in(user)

        delete group_membership_path(group, membership)
        user.reload
        expect(user.groups.include?(group)).to be false
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
