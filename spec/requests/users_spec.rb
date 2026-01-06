require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get user_path(user)
      expect(response).to be_successful
    end
  end
end
