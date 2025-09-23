require 'rails_helper'

RSpec.describe 'Dashboard', type: :system do
  describe 'notifications' do
    it 'shows unread notifications and removes them after clicking' do
      user = create(:user)
      talk = create(:talk)
      user.groups << talk.group
      comment = create(:comment, talk:)
      create(:comment_notification, user:, notifiable: comment)
      log_in_as user

      expect(page).to have_css('.notification')
      click_on "#{talk.title}に#{comment.user.nickname}よりコメントがありました"
      expect(page).to have_content(talk.description)
      click_on 'トップへ戻る'
      expect(page).to have_no_content("#{talk.title}に#{comment.user.nickname}よりコメントがありました")
    end
  end
end
