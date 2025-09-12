require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#member_of?' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    context 'when user is not member of the group' do
      it 'returns false' do
        expect(user.member_of?(group)).to be false
      end
    end

    context 'when user is member of the group' do
      before do
        create(:membership, user: user, group: group)
      end

      it 'returns true' do
        expect(user.member_of?(group)).to be true
      end
    end
  end
end
