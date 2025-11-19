require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'name' do
    context 'when it is empty' do
      it 'is invalid' do
        group = build(:group, name: '', admin: create(:user))
        expect(group).to be_invalid
      end
    end

    context 'when it is long name' do
      it 'is invalid' do
        group = build(:group, name: "50文字以上のグループ名#{'あ'*50}", admin: create(:user))
        expect(group).to be_invalid
      end
    end
  end

  describe '#member_count' do
    it 'returns the number of users associated with the group' do
      group = create(:group)
      user = create(:user)
      create(:membership, user:, group:)

      expect(group.member_count).to eq(1)
    end
  end

  describe '#last_valid_invitation' do
    it 'returns the invitation if a valid one exists' do
      group = create(:group)
      invitation = create(:invitation, group:)

      expect(group.last_valid_invitation).to eq invitation
    end

    it 'returns nil if there is no valid invitation' do
      group = create(:group)
      create(:invitation, group:, expires_at: Time.current.yesterday)

      expect(group.last_valid_invitation).to be_nil
    end
  end
end
