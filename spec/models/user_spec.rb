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
        create(:membership, user:, group:)
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
        image: ActionController::Base.helpers.asset_path('test_user_icon.png')
      )
      expect(user.email).to start_with('dummy_email_')
      expect(user.uid).to start_with('dummy_uid_')
      expect(user.deleted_at).not_to be_nil
    end
  end

  describe '#deleted?' do
    it 'returns true when the user is soft-deleted' do
      user.soft_delete!
      expect(user.reload.deleted?).to be true
    end
  end

  describe '.find_or_initialize_from_auth_hash!' do
    it 'returns the user when the user is found' do
      expect(described_class.find(user.id)).to eq user
      found_user = described_class.find_or_initialize_from_auth_hash!(google_mock(user))
      expect(found_user.name).to eq user.name
      expect(found_user.email).to eq user.email
      expect(found_user.uid).to eq user.uid
    end

    it 'creates a new user when none is found' do
      new_user = described_class.new(
        name: 'dummy',
        email: 'dummy@example.com',
        uid: 'dummy_uid',
        image: ActionController::Base.helpers.asset_path('test_user_icon.png')
      )
      expect(described_class.find_by(id: new_user.id)).to be_nil
      created_user = described_class.find_or_initialize_from_auth_hash!(google_mock(new_user))
      expect(created_user.name).to eq new_user.name
      expect(created_user.email).to eq new_user.email
      expect(created_user.uid).to eq new_user.uid
    end
  end
end
