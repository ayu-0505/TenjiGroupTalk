require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:commenter) { create(:user) }
  let(:recipient) { create(:user) }
  let(:group) { create(:group) }
  let(:talks) { create_list(:talk, 5, user: recipient, group:) }

  before do
    commenter.groups << group
    recipient.groups << group
  end

  describe '.unread' do
    before do
      talks.each do |talk|
        comment = create(:comment, user: commenter, talk:)
        create(:comment_notification, user: recipient, notifiable: comment)
      end
    end

    it 'returns only unread notifications' do
      expect(recipient.notifications.unread.size).to eq 5
      comment1 = talks[0].comments.last
      read_notification = recipient.notifications.find_by(notifiable: comment1)
      read_notification.update(read: true)
      expect(recipient.notifications.unread.size).to eq 4
    end
  end

  describe '#link_title' do
    it 'returns the talk title and the commenter when the notifiable is a comment' do
      talks[0].subscribers << recipient
      comment = create(:comment, user: commenter, talk: talks[0])
      described_class.create(user: recipient, notifiable: comment)
      notification = described_class.find_by(user: recipient)

      expect(notification.link_title).to eq "#{talks[0].title}に#{comment.user.name}よりコメントがありました"
    end
  end

  describe '#link_path' do
    it 'returns the talk path when the notifiable is a comment' do
      talks[0].subscribers << recipient
      comment = create(:comment, user: commenter, talk: talks[0])
      described_class.create(user: recipient, notifiable: comment)
      notification = described_class.find_by(user: recipient)

      expect(notification.link_path).to eq "/groups/#{group.id}/talks/#{talks[0].id}"
    end
  end
end
