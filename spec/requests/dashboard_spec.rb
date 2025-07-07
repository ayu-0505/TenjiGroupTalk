require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /dashboard" do
    it 'display contents only login user' do
      user = create(:user)
      log_in_as(user)

      expect(page).to have_text('ログイン後ルート画面')
    end
  end
end
