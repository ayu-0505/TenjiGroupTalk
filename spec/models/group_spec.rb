require 'rails_helper'

RSpec.describe Group, type: :model do
 describe 'name' do
    context 'when it is empty' do
      it 'is invalid' do
        group = described_class.new(name: '')
        expect(group.valid?).to be(false)
        expect(group.errors[:name]).to include('を入力してください')
      end
    end
  end
end
