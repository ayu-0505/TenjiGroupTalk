require 'rails_helper'

RSpec.describe Braille, type: :model do
  let(:user) { create(:user) }
  let(:braille) { create(:braille, user:) }

  describe 'when creating a new braille without original_text' do
    it "sets raised_braille to nil when original_text is blank" do
      braille = described_class.new(original_text: '')
      braille.send(:initialize_braille)
      expect(braille.raised_braille).to be_nil
      expect(braille.indented_braille).to be_nil
    end
  end

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
