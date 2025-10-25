require 'rails_helper'

RSpec.describe CommentsHelper, type: :helper do
  let(:comments) { create_list(:comment, 10) }

  describe '#display_comments' do
    it 'returns initial comments' do
      expect(display_comments(comments)).to eq comments[5..-1]

      comments[3..].each do |comment|
        comment.destroy
      end
      remaining_comments = comments[0].talk.comments
      expect(display_comments(remaining_comments)).to eq remaining_comments
    end
  end

  describe '#hidden_comments' do
    it 'returns hidden comments' do
      expect(hidden_comments(comments)).to eq comments[0..4]
    end

    it 'returns empty array if comments are fewer than the initial count' do
       comments[3..].each do |comment|
        comment.destroy
      end
      remaining_comments = comments[0].talk.comments
      expect(hidden_comments(remaining_comments)).to eq []
    end
  end

  describe '#ids' do
    it 'returns an array of comment ids' do
      expect(ids(comments)).to eq comments.pluck(:id)
    end
  end
end
