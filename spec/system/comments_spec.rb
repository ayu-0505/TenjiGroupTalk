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

  describe 'create a new comment', :js do
    it 'creates a comment with valid input' do
      visit group_talk_path(group, talk)
      fill_in 'コメント内容', with: '面白そう！'
      click_on '新規作成'
      expect(page).to have_content('面白そう！')
      expect(page).to have_content("コメント （#{talk.reload.comments.size}）")
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
      expect(page).to have_content("コメント （#{talk.reload.comments.size}）")
    end
  end

  describe 'converts text to braille in the form', :js do
    context 'when clicking the convert button in the new form' do
      it 'converts to raised braille and indented braille' do
        visit group_talk_path(group, talk)
        within("#new_comment") do
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
        within("#comment_#{comments[0].id}") do
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
        within("#comment_#{comments[0].id}") do
          click_on 'コメントを編集する'
        end

        within(".edit_comment") do
          fill_in 'ひらがな文', with: 'こんにちわ'
          click_button '変換'
        end

        within("#comment_#{comments[2].id}") do
          expect(page).to have_no_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
          expect(page).to have_no_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
        end
      end
    end
  end

  describe 'has a braille with toggle visiblity button' do
    it 'shows a toggle buttonand allows switching visibility', :js do
      braille = create(:braille, user:)
      comments[0].update!(braille:)
      visit group_talk_path(group, talk)

      within "#comment_#{comments[0].id}" do
        expect(page).to have_css('.original_text.hidden', visible: :all)
        expect(page).to have_content ("#{braille.raised_braille}")
        expect(page).to have_content ("#{braille.indented_braille}")

        find('.original_text_display_btn').click
        expect(page).to have_content ("#{braille.original_text}")

        find('.raised_braille_display_btn').click
        expect(page).to have_css('.raised_braille.hidden', visible: :all)

        find('.indented_braille_display_btn').click
        expect(page).to have_css('.indented_braille.hidden', visible: :all)
      end
    end
  end

  describe 'collapse comments', :js do
    it 'displays initial comments' do
      additional_comments = create_list(:comment, 10, talk: talk, user: user)
      visit group_talk_path(group, talk)
      all_comments = comments + additional_comments
      initial_comments = all_comments[-CommentsHelper::INITIAL_DISPLAY_COUNT..]
      hidden_comments = all_comments[0..-(CommentsHelper::INITIAL_DISPLAY_COUNT + 1)]

      expect(page).to have_content "コメント （#{all_comments.size}）"
      expect(page).to have_content "コメントを読み込む (#{all_comments.size - CommentsHelper::INITIAL_DISPLAY_COUNT})"
      initial_comments.each do |comment|
        expect(page).to have_content(comment.description)
      end
      hidden_comments.each do |comment|
        expect(page).to have_no_content(comment.description)
      end
    end

    it 'displays a few more comments each time the button is clicked' do
      additional_comments = create_list(:comment, 10, talk: talk, user: user)
      visit group_talk_path(group, talk)
      all_comments = comments + additional_comments
      hidden_comments = all_comments[0...-CommentsHelper::INITIAL_DISPLAY_COUNT]
      hidden_count = hidden_comments.size

      hidden_comments.reverse.each_slice(CommentsHelper::INITIAL_DISPLAY_COUNT) do |next_comments|
        click_on "コメントを読み込む (#{hidden_count})"
        next_comments.reverse.each do |comment|
          expect(page).to have_content(comment.description)
        end
        hidden_count -= CommentsHelper::INITIAL_DISPLAY_COUNT
      end
      expect(page).to have_no_content('コメントを読み込む')
    end
  end
end
