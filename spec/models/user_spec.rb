require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  describe '#display_name' do
    it 'returns the nickname if it is present' do
      user.nickname = 'あだ名'
      expect(user.display_name).to eq user.nickname
      user.nickname = nil
      expect(user.display_name).to eq user.name
    end
  end

  describe '#member_of?' do
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

  describe '#soft_delete!' do
    it 'updates deleted_at, name, email, uid and image (soft-delete)' do
      expect(user.deleted_at).to be_nil
      user.soft_delete!
      expect(user.reload).to have_attributes(
        name: 'deleted_name',
        email: 'deleted_email',
        uid: 'deleted_uid',
        image: ActionController::Base.helpers.asset_path('test_user_icon.png')
      )
      expect(user.deleted_at).not_to be_nil
    end
  end

  describe 'deleted?' do
    it 'returns true when the user is soft-deleted' do
      user.soft_delete!
      expect(user.reload.deleted?).to be true
    end
  end
end
