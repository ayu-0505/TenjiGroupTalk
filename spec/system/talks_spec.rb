require 'rails_helper'

RSpec.describe 'Talks', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:group) { create(:group) }
  let!(:talks) { create_list(:talk, 3, user:, group:) }

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
        within('.talk') do
          expect(page).to have_no_content('編集する')
          expect(page).to have_no_content('削除する')
        end
      end
    end

    context 'when the subscription toggle button is OFF' do
      it 'turns ON, creates the subscription, and shows a flash message', :js do
        visit group_talk_path(group, talks[0])

        span = find('span[data-subscription-toggle-target="switch"]')
        expect(span[:class]).to include('bg-sky-300')
        expect(span[:class]).to include('left-0.5')
        find('label[for="subscription_check"]').click
        expect(page).to have_content '通知登録しました'
        expect(span[:class]).to include('bg-sky-600')
        expect(span[:class]).to include('left-5')

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
        expect(span[:class]).to include('left-5')
        find('label[for="subscription_check"]').click
        expect(page).to have_content '通知登録を解除しました'

        expect(Subscription.find_by(id: subscription_id)).to be_nil
        expect(span[:class]).to include('bg-sky-300')
        expect(span[:class]).to include('left-0.5')
      end
    end
  end

  describe 'create a new talk' do
    it 'creates a talk with valid input', :js do
      visit group_talks_path(group)
      click_on 'トークテーマを作成する'
      fill_in 'タイトル', with: '点字しりとり！'
      fill_in '内容', with: '点字を使ってしりとりしましょう'
      expect(page).to have_button('トークを作成する', disabled: false)
      click_on 'トークを作成する'
      expect(page).to have_content('トークが作成されました！')
      expect(page).to have_content('点字しりとり！')
      expect(page).to have_content('点字を使ってしりとりしましょう')
    end
  end

  describe 'update the talk', :js do
    it 'updates the talk with valid input' do
      visit group_talk_path(group, talks[0])
      within('.talk') do
        click_on '編集する'
      end
      fill_in 'タイトル', with: '新規トーク'
      fill_in '内容', with: 'これは新しいトークです！'
      expect(page).to have_button('トークを更新する', disabled: false)
      click_on 'トークを更新する'
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
      within('.talk') do
        expect(page).to have_text('削除する')
        page.accept_confirm 'トークを削除します。一度削除すると元に戻すことはできません。本当によろしいですか？' do
          click_on '削除する'
        end
      end
      expect(page).to have_content('トークは削除されました')
      expect(page).to have_no_content(talks[0].title)
    end
  end

  describe 'converts text to braille in the form', :js do
    context 'when clicking the convert button in the new form' do
      it 'converts to raised braille and indented braille' do
        visit new_group_talk_path(group)
        fill_in '点字クイズにする言葉をひらがなで入力', with: 'こんにちわ'
        click_button '点字を確認する'

        expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
        expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
      end
    end

    context 'when clicking the convert button in the edit form' do
      it 'converts to raised braille and indented braille' do
        visit edit_group_talk_path(group, talks[0])
        fill_in '点字クイズにする言葉をひらがなで入力', with: 'こんにちわ'
        click_button '点字を確認する'

        expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
        expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
      end
    end
  end

  describe 'a braille quiz is provided with a button to reveal the correct answer', :js do
    before do
      visit edit_group_talk_path(group, talks[0])
      fill_in '点字クイズにする言葉をひらがなで入力', with: 'こんにちわ'
      click_button 'トークを更新する'
    end

    it 'can reveal the correct hiragana for the braille quiz', :js do
      within '#talk_braille' do
        expect(page).to have_content ("#{Braille.last.raised_braille}")
        expect(page).to have_content ("#{Braille.last.indented_braille}")
        expect(page).to have_css('.talk_original_text.hidden', visible: :all)

        click_on '正解を見る'
        expect(page).to have_content ("#{Braille.last.original_text}")
      end
    end

    it 'hides the correct hiragana when the button is pressed', :js do
      within '#talk_braille' do
        click_on '正解を見る'
        expect(page).to have_content '正解をかくす'
        click_on '正解をかくす'
        expect(page).to have_css('.talk_original_text.hidden', visible: :all)
      end
    end
  end

  describe 'disables the buttons when the form is blank', :js do
    it 'disables the convert button' do
      visit edit_group_talk_path(group, talks[0])
      expect(find_field('点字クイズにする言葉をひらがなで入力').value).to eq('')
      button = find('button[data-disable-button-target="whiteBtn"]', visible: :all)
      expect(button[:disabled]).to eq('true')

      visit group_talk_path(group, talks[0])
      expect(find_field('点字クイズにする言葉をひらがなで入力').value).to eq('')
      button = find('button[data-disable-button-target="whiteBtn"]', visible: :all)
      expect(button[:disabled]).to eq('true')
    end

    it 'disables the submit button' do
      visit new_group_talk_path(group)
      expect(find_field('タイトル').value).to eq('')
      expect(find_field('トーク内容').value).to eq('')
      button = find('input[value="トークを作成する"]', visible: :all)
      expect(button[:disabled]).to eq('true')
    end
  end
end
