require 'rails_helper'

RSpec.describe CommentBrailleForm, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:talk) { create(:talk, group:, user:) }
  let(:comment) { create(:comment, user:, talk:) }

  describe '#save' do
    context 'when there are validation errors' do
      it 'returns false' do
        form = described_class.new(user:, talk:, attributes: { description: '' })
        expect(form.save).to be false
      end
    end

    context 'when original_text is present' do
      it 'creates comment and braille and returns true' do
        form = described_class.new(user:, talk:, attributes: { description: 'test description', attributes: { original_text: 'てんじ' } })
        expect(form.save).to be true
        expect(form.comment).to be_valid
        expect(form.comment.braille).to be_valid
      end
    end

    context 'when original_text is not present' do
      it 'creates comment without braille and returns true' do
        form = described_class.new(user:, talk:, attributes: { description: 'test description', attributes: { original_text: '' } })
        expect(form.save).to be true
        expect(form.comment).to be_valid
        expect(form.comment.braille).to be_nil
      end
    end
  end

  describe '#update' do
    shared_context 'with original_text' do
       let(:form) { described_class.new(user:, talk:, comment:, attributes: { description: 'valid description', original_text: 'てんじ' }) }
    end

    shared_context 'without original_text' do
       let(:form) { described_class.new(user:, talk:, comment:, attributes: { description: 'valid description' }) }
    end

    shared_context 'with existing braille' do
      let(:existing_braille) { create(:braille, user:) }
      let(:comment) { create(:comment, user:, talk:, braille: existing_braille) }
    end

    context 'when there are validation errors' do
      it 'returns false' do
        form = described_class.new(user:, talk:, comment:, attributes: { description: '' })
        expect(form.save).to be false
      end
    end

    context 'when original_text is blank and a braille already exists' do
      include_context 'without original_text'
      include_context 'with existing braille'

      it 'updates the talk, deletes the existing braille and returns true' do
        expect(form.update).to be true
        comment = form.comment
        expect(comment.description).to eq 'valid description'
        expect(comment.braille).to be_nil
      end
    end

    context 'when original_text is blank and no braille exists' do
      include_context 'without original_text'

      it 'updates the talk and returns true' do
        expect(form.update).to be true
        comment = form.comment
        expect(comment.description).to eq 'valid description'
        expect(comment.braille).to be_nil
      end
    end

    context 'when original_text is present and a braille exists with different original_text' do
      include_context 'with original_text'
      include_context 'with existing braille'

      it 'updates the talk and the braille, and returns true' do
        expect(form.update).to be true
        comment = form.comment
        expect(comment.description).to eq 'valid description'
        expect(comment.braille.id).to eq existing_braille.id
        expect(comment.braille.original_text).to eq form.attributes['original_text']
      end
    end

    context 'when original_text is present and a braille exists with the same original_text' do
      include_context 'with existing braille'
      let(:form) { described_class.new(
        user:,
        talk:,
        comment:,
        attributes: {
          description: 'valid description',
          original_text: existing_braille.original_text
        })}

      it 'updates only the comment and returns true' do
        existing_id = existing_braille.id
        expect(form.update).to be true
        comment = form.comment
        expect(comment.description).to eq 'valid description'
        expect(comment.braille.id).to eq existing_id
        expect(comment.braille.original_text).to eq form.attributes['original_text']
      end
    end

    context 'when original_text is present and no braille exists' do
      include_context 'with original_text'

      it 'updates the comment, creates a new braille and returns true' do
        expect(form.comment.braille).to be_nil
        expect(form.update).to be true
        comment = form.comment
        expect(comment.description).to eq 'valid description'
        expect(comment.braille.original_text).to eq form.attributes['original_text']
      end
    end
  end

  describe '#form_with_options' do
    context 'when the comment already exists' do
      it 'returns the update URL with the patch method' do
        form = described_class.new(user:, talk:, comment:)
        expect(form.form_with_options).to eq ({ url: "/talks/#{talk.id}/comments/#{comment.id}", method: :patch })
      end
    end

    context 'when the comment does not exist' do
      it 'returns the create URL with the post method' do
        form = described_class.new(user:, talk:)
        expect(form.form_with_options).to eq ({ url: "/talks/#{talk.id}/comments", method: :post })
      end
    end
  end
end
