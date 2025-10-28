require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe '#expired?' do
    it 'returns false if within 7 days from token creation' do
      invitation = create(:invitation)
      expect(invitation.expired?).to be false
    end

    it 'returns true after that' do
      invitation = create(:invitation, expires_at: Time.current.yesterday)
      expect(invitation.expired?).to be true
    end
  end
end
