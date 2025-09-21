require 'rails_helper'

RSpec.describe 'Talks', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:group) { create(:group) }
  let!(:talks) { create_list(:talk, 3, user: user, group: group) }

  before do
    group.users << user
    log_in_as user
  end

  describe 'show talks list' do
    it 'displays a list of talks' do
      visit group_talks_path(group)
      expect(page).to have_css('.talk', count: 3)
      expect(page).to have_text(talks[0].title)
      expect(page).to have_text(talks[1].title)
      expect(page).to have_text(talks[2].title)
    end
  end

  describe 'show the talk' do
    it 'displays the talk' do
      visit group_talk_path(group, talks[0])
      expect(page).to have_text(talks[0].title)
      expect(page).to have_text(talks[0].description)
    end

    describe 'subscription button at the talk' do
      before do
        group.users << other_user
        log_in_as other_user
      end

      it 'creates a subscription when the subscribe button is OFF and clicked' do
        expect(other_user.subscriptions.find_by(talk: talks[0]).present?).to be false

        visit group_talk_path(group, talks[0])
        find_by_id('create_subscription').click

        expect(other_user.subscriptions.find_by(talk: talks[0]).present?).to be true
        expect(page).to have_css '#delete_subscription'
      end

      it 'destroys the subscription when the subscribe button is ON and clicked' do
        Subscription.create(user: other_user, talk: talks[0])
        expect(other_user.subscriptions.find_by(talk: talks[0]).present?).to be true

        visit group_talk_path(group, talks[0])
        find_by_id('delete_subscription').click

        expect(other_user.subscriptions.find_by(talk: talks[0]).present?).to be false
        expect(page).to have_css '#create_subscription'
      end
    end

    context 'when the user is not the talk owner' do
      before do
        group.users << other_user
        log_in_as other_user
      end

      it 'does not display the edit and delete links' do
         visit group_talk_path(group, talks[0])
          expect(page).to have_content(talks[0].title)
         expect(page).to have_no_content('トークを編集する')
         expect(page).to have_no_content('トークを削除する')
      end
    end
  end

  describe 'create a new talk' do
    it 'creates a talk with valid input' do
      visit group_talks_path(group)
      click_on '新しいトークを作成する'
      fill_in 'タイトル', with: '点字しりとり！'
      fill_in '内容', with: '点字を使ってしりとりしましょう'
      click_on 'トークを作成'
      expect(page).to have_content('トークが作成されました！')
      expect(page).to have_content('点字しりとり！')
      expect(page).to have_content('点字を使ってしりとりしましょう')
    end

    describe 'auto subscription' do
      before do
        group.users << other_user
        log_in_as other_user
      end

      it 'creates a new subscription and shows the delete button on the talk' do
        visit group_talks_path(group)
        click_on '新しいトークを作成する'
        fill_in 'タイトル', with: '点字しりとり！'
        fill_in '内容', with: '点字を使ってしりとりしましょう'
        click_on 'トークを作成'

        expect(page).to have_css '#delete_subscription'
      end
    end
  end

  describe 'update the talk' do
    it 'updates the talk with valid input' do
      visit group_talk_path(group, talks[0])
      click_on 'トークを編集する'
      fill_in 'タイトル', with: '新規トーク'
      fill_in '内容', with: 'これは新しいトークです！'
      click_on 'トークを更新'
      expect(page).to have_content('トークを更新しました！')
      expect(page).to have_no_content(talks[0].title)
      expect(page).to have_no_content(talks[0].description)
      expect(page).to have_content('新規トーク')
      expect(page).to have_content('これは新しいトークです！')
    end
  end

  describe 'delete the talk', :js do
    it 'deletes the talk' do
      visit group_talk_path(group, talks[0])
      expect(page).to have_text(talks[0].title)
      expect(page).to have_text('トークを削除する')
      page.accept_confirm 'トークを削除します。一度削除すると元に戻すことはできません。本当によろしいですか？' do
        click_on 'トークを削除する'
      end
      expect(page).to have_content('トークは削除されました')
      expect(page).to have_no_content(talks[0].title)
    end
  end

  describe 'converts text to braille in the form', :js do
    context 'when clicking the convert button in the new form' do
      it 'converts to raised braille and indented braille' do
        visit new_group_talk_path(group)
        fill_in 'ひらがな文', with: 'こんにちわ'
        click_button '変換'

        expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
        expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
      end
    end

    context 'when clicking the convert button in the edit form' do
      it 'converts to raised braille and indented braille' do
        visit edit_group_talk_path(group, talks[0])
        fill_in 'ひらがな文', with: 'こんにちわ'
        click_button '変換'

        expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
        expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
      end
    end
  end
end
