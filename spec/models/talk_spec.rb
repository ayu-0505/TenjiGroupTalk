require 'rails_helper'

RSpec.describe Talk, type: :model do
  let(:group) { create(:group) }
  let(:talks) { create_list(:talk, 10, group:) }

  describe '.sort_by_latest_comments' do
    it 'orders talks by the latest comment updated_at, or by talk updated_at when no comments exist' do
      comments = talks[5..9].map { |talk| create(:comment, talk:) }
      base_time = Time.current
      # NOTE: talksがid[4, 3, 2, 1]に並ぶ
      talks[0..3].each_with_index do |talk, i|
        talk.update_columns(updated_at: base_time + i.seconds)
      end
      # NOTE: talksがid[10, 9, 8, 7, 6]に並び、こちらの更新が最新となる
      comments.each_with_index do |comment, i|
         comment.update_columns(updated_at: base_time + (i+10).seconds)
      end
      result = group.talks.sort_by_latest_comments
      expect(result).to eq [ talks[9], talks[8], talks[7], talks[6], talks[5], talks[3], talks[2], talks[1], talks[0], talks[4] ]
    end
  end
end
