require 'rails_helper'

RSpec.describe Braille, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, user: user) }
  let(:talk) { create(:talk, user: user) }
  let(:braille) { create(:talk_braille, user: user) }

  # WARNING: 点字のスペースはスペースのコードではなく、点字の無点（U+2800）
  describe 'same_content?' do
    context 'when same text' do
      it 'returns true' do
        expect(braille.same_content?(braille.original_text)).to be true
      end
    end

    context 'when different text' do
      it 'returns true' do
        expect(braille.same_content?('ちがうひらがな')).to be false
      end
    end
  end
end
