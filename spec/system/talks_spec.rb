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

    context 'when the content contains braille' do
      it 'shows a toggle buttonand allows switching visibility', :js do
        braille = create(:braille, user:)
        talks[0].update!(braille:)
        visit group_talk_path(group, talks[0])

        expect(page).to have_css('.original_text.hidden', visible: :all)
        expect(page).to have_content ("#{braille.raised_braille}")
        expect(page).to have_content ("#{braille.indented_braille}")

        within '.talk' do
          find('label[for="talk_original_text_check"]').click
          expect(page).to have_content ("#{braille.original_text}")

          find('label[for="talk_raised_check"]').click
          expect(page).to have_css('.raised_braille.hidden', visible: :all)

          find('label[for="talk_indented_check"]').click
          expect(page).to have_css('.indented_braille.hidden', visible: :all)
        end
      end
    end

    context 'when the subscription toggle button is OFF' do
      it 'turns ON, creates the subscription, and shows a flash message', :js do
        visit group_talk_path(group, talks[0])

        span = find('span[data-subscription-toggle-target="switch"]')
        expect(span[:class]).to include('bg-sky-300')
        find('label[for="subscription_check"]').click
        expect(page).to have_content '通知登録しました'
        expect(span[:class]).to include('bg-sky-600')

        subscription = Subscription.last
        expect(subscription.user_id).to eq user.id
        expect(subscription.talk_id).to eq talks[0].id
      end
    end

    context 'when the subscription toggle button is ON' do
      it 'turns OFF, deletes the subscription, and shows a flash message', :js do
        subscription_id = Subscription.create(user:, talk: talks[0]).id
        visit group_talk_path(group, talks[0])

        span = find('span[data-subscription-toggle-target="switch"]')
        expect(span[:class]).to include('bg-sky-600')
        find('label[for="subscription_check"]').click
        expect(page).to have_content '通知登録を解除しました'

        expect(Subscription.find_by(id: subscription_id)).to be_nil
        expect(span[:class]).to include('bg-sky-300')
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
