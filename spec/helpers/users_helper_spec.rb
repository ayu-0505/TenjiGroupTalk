require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
let(:user) { create(:user) }

  describe '#display_user_name' do
    it 'returns a dimmed nickname for a soft-deleted user' do
      user.soft_delete!
      expect(display_user_name(user)).to have_css('span.text-gray-400', text: "#{user.nickname}")
    end

    it 'returns a normal nickname for an active user' do
      expect(display_user_name(user)).to eq user.nickname
    end
  end
end
