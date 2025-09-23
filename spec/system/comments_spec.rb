require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }
  let(:non_owner_user) { create(:user) }
  let!(:group) { create(:group) }
  let!(:talk) { create(:talk, group: group, user: user) }
  let!(:comments) { create_list(:comment, 5, talk: talk, user: user) }

  before do
    group.users << user
    group.users << non_owner_user
    log_in_as user
  end

  describe 'show comments' do
    it 'displays a list of comments at the talk' do
      visit group_talk_path(group, talk)
      expect(page).to have_css('.comment', count: 5)
      expect(page).to have_text(comments[0].description)
      expect(page).to have_text(comments[0].description)
      expect(page).to have_text(comments[0].description)
    end
  end

  describe 'create a new comment' do
    it 'creates a comment with valid input' do
      visit group_talk_path(group, talk)
      fill_in 'コメント内容', with: '面白そう！'
      click_on '新規作成'
      expect(page).to have_content('面白そう！')
    end
  end

  describe 'update the comment' do
    it 'updates the comment with valid input' do
      visit group_talk_path(group, talk)
      click_on 'コメントを編集する', match: :first
      fill_in 'コメント内容', with: '新規コメント', match: :first
      click_on '更新', match: :first
      expect(page).to have_content('新規コメント')
      expect(page).to have_no_content(comments[0].description)
    end
  end

  describe 'delete the comment', :js do
    it 'deletes the comment' do
      visit group_talk_path(group, talk)
      expect(page).to have_text(comments[1].description)
      expect(page).to have_text('コメントを削除する')
      page.accept_confirm 'コメントを削除します。よろしいですか？' do
        click_on 'コメントを削除する', match: :first
      end
      expect(page).to have_content(comments[1].description)
      expect(page).to have_no_content(comments[0].description)
    end
  end

  describe 'converts text to braille in the form', :js do
    context 'when clicking the convert button in the new form' do
      it 'converts to raised braille and indented braille' do
        visit group_talk_path(group, talk)
        within(".new_comment") do
          fill_in 'ひらがな文', with: 'こんにちわ'
          click_button '変換'

          expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
          expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
        end
      end
    end

    context 'when clicking the convert button in the first comment' do
      it 'converts to raised braille and indented braillein the first comment' do
        visit group_talk_path(group, talk)
        within(".comment#comment_#{comments[0].id}") do
          click_on 'コメントを編集する'
        end

        within(".edit_comment") do
          fill_in 'ひらがな文', with: 'こんにちわ'
          click_button '変換'

          expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
          expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
        end
      end

      it "does not convert the text in other comments" do
        visit group_talk_path(group, talk)
        within(".comment#comment_#{comments[0].id}") do
          click_on 'コメントを編集する'
        end

        within(".edit_comment") do
          fill_in 'ひらがな文', with: 'こんにちわ'
          click_button '変換'
        end

        within(".comment#comment_#{comments[2].id}") do
          expect(page).to have_no_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
          expect(page).to have_no_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
        end
      end
    end
  end
end
