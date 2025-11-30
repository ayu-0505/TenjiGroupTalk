require 'rails_helper'

RSpec.describe 'Dashboard', type: :system do
  let(:user) { create(:user) }
  let(:talk) { create(:talk) }

  before do
    user.groups << talk.group
    log_in_as user
  end


  describe 'notifications' do
    it 'shows unread notifications and removes them after clicking' do
      comment = create(:comment, talk:)
      create(:notification, user:, comment:)

      visit root_path
      find_by_id('notification-menu').click
      expect(page).to have_content("#{talk.title}に#{comment.user.nickname}よりコメントがありました")
      click_on "#{talk.title}に#{comment.user.nickname}よりコメントがありました"
      expect(page).to have_content(talk.description)
      find_by_id('notification-menu').click
      expect(page).to have_no_content("#{talk.title}に#{comment.user.nickname}よりコメントがありました")
    end
  end

  describe 'menu' do
    it 'shows a list of links when the menu is opened' do
      visit root_path
      find('img[alt="メニューボタンの３本線マーク"]').click
      within('#hamburger-menu') do
        expect(page).to have_link('トップページ')
        expect(page).to have_link('グループ')
        expect(page).to have_link('プロフィール')
        expect(page).to have_link('ログアウト')
      end
    end

    it 'closes the menu when clicking outside of it' do
      visit root_path
      find('img[alt="メニューボタンの３本線マーク"]').click
      within('#hamburger-menu') do
        expect(page).to have_link('ログアウト')
      end
      find('body').click
      expect(page).to have_css('#hamburger-menu', visible: :false)
    end
  end
end
