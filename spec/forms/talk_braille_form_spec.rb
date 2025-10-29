require 'rails_helper'

RSpec.describe TalkBrailleForm, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:talk) { create(:talk, group:, user:) }

  describe '#save' do
    context 'when there are validation errors' do
      it 'returns false' do
        form = described_class.new(user:, group:, attributes: { title: 'test', description: '' })
        expect(form.save).to be false
      end
    end

    context 'when original_text is present' do
      it 'creates talk and braille and returns true' do
        form = described_class.new(user:, group:, attributes: { title: 'test', description: 'test description', attributes: { original_text: 'てんじ' } })
        expect(form.save).to be true
        expect(form.talk).to be_valid
        expect(form.talk.braille).to be_valid
      end
    end

    context 'when original_text is not present' do
      it 'creates talk without braille and returns true' do
        form = described_class.new(user:, group:, attributes: { title: 'test', description: 'test description', attributes: { original_text: '' } })
        expect(form.save).to be true
        expect(form.talk).to be_valid
        expect(form.talk.braille).to be_nil
      end
    end
  end

  describe '#update' do
    shared_context 'with original_text' do
       let(:form) { described_class.new(user:, group:, talk:, attributes: { title: 'Valid title', description: 'valid description', original_text: 'てんじ' }) }
    end

    shared_context 'without original_text' do
       let(:form) { described_class.new(user:, group:, talk:, attributes: { title: 'Valid title', description: 'valid description' }) }
    end

    shared_context 'with existing braille' do
      let(:existing_braille) { create(:braille, user:) }
      let(:talk) { create(:talk, group:, user:, braille: existing_braille) }
    end

    context 'when there are validation errors' do
      it 'returns false' do
        form = described_class.new(user:, group:, attributes: { title: '', description: '' })
        expect(form.save).to be false
      end
    end

    context 'when original_text is blank and a braille already exists' do
      include_context 'without original_text'
      include_context 'with existing braille'

      it 'updates the talk, deletes the existing braille and returns true' do
        expect(form.update).to be true
        talk = form.talk
        expect(talk.title).to eq 'Valid title'
        expect(talk.description).to eq 'valid description'
        expect(talk.braille).to be_nil
      end
    end

    context 'when original_text is blank and no braille exists' do
      include_context 'without original_text'

      it 'updates the talk and returns true' do
        expect(form.update).to be true
        talk = form.talk
        expect(talk.title).to eq 'Valid title'
        expect(talk.description).to eq 'valid description'
        expect(talk.braille).to be_nil
      end
    end

    context 'when original_text is present and a braille exists with different original_text' do
      include_context 'with original_text'
      include_context 'with existing braille'

      it 'updates the talk and the braille, and returns true' do
        expect(form.update).to be true
        talk = form.talk
        expect(talk.title).to eq 'Valid title'
        expect(talk.description).to eq 'valid description'
        expect(talk.braille.id).to eq existing_braille.id
        expect(talk.braille.original_text).to eq form.attributes['original_text']
      end
    end

    context 'when original_text is present and a braille exists with the same original_text' do
      include_context 'with existing braille'
      let(:form) { described_class.new(
        user:,
        group:,
        talk:,
        attributes: {
          title: 'Valid title',
          description: 'valid description',
          original_text: existing_braille.original_text
        })}

      it 'updates only the talk and returns true' do
        existing_id = existing_braille.id
        expect(form.update).to be true
        talk = form.talk
        expect(talk.title).to eq 'Valid title'
        expect(talk.description).to eq 'valid description'
        expect(talk.braille.id).to eq existing_id
        expect(talk.braille.original_text).to eq form.attributes['original_text']
      end
    end

    context 'when original_text is present and no braille exists' do
      include_context 'with original_text'

      it 'updates the talk, creates a new braille and returns true' do
        expect(form.talk.braille).to be_nil
        expect(form.update).to be true
        talk = form.talk
        expect(talk.title).to eq 'Valid title'
        expect(talk.description).to eq 'valid description'
        expect(talk.braille.original_text).to eq form.attributes['original_text']
      end
    end
  end

  describe '#form_with_options' do
    context 'when the talk already exists' do
      it 'returns the update URL with the patch method' do
        form = described_class.new(user:, group:, talk:)
        expect(form.form_with_options).to eq ({ url: "/groups/#{group.id}/talks/#{talk.id}", method: :patch })
      end
    end

    context 'when the talk does not exist' do
      it 'returns the create URL with the post method' do
        form = described_class.new(user:, group:)
        expect(form.form_with_options).to eq ({ url: "/groups/#{group.id}/talks", method: :post })
      end
    end
  end
end
