require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /dashboard" do
    let(:user) { create(:user) }

    it 'display contents only login user' do
      log_in_as(user)

      expect(page).to have_text('ダッシュボード')
    end
  end
end
