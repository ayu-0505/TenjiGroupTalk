require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
let(:user) { create(:user) }

  describe '#user_name_tag' do
    it 'returns a dimmed nickname for a soft-deleted user' do
      user.soft_delete!
      expect(user_name_tag(user)).to have_css('span.text-gray-400', text: "#{user.nickname}")
    end

    it 'returns a nomal display name for an active user' do
      expect(user_name_tag(user)).to eq (user.nickname || usr.name)
    end
  end
end
