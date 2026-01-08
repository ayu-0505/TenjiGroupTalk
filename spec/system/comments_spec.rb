require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }
  let(:non_owner_user) { create(:user) }
  let!(:group) { create(:group) }
  let!(:talk) { create(:talk, group:, user:) }
  let!(:comments) { create_list(:comment, 5, talk:, user:) }

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
      click_on 'コメントを投稿する'
      expect(page).to have_content('面白そう！')
      expect(page).to have_content("コメント （#{talk.reload.comments.size}）")
    end
  end

  describe 'update the comment' do
    it 'updates the comment with valid input', :js do
      visit group_talk_path(group, talk)
      within("#comment_#{comments[0].id}") do
        click_on 'コメント内容を編集する', match: :first
        fill_in 'コメント内容', with: '新規コメント', match: :first
        click_on 'コメントを更新する', match: :first
      end
      expect(page).to have_content('新規コメント')
      expect(page).to have_no_content(comments[0].description)
    end
  end

  describe 'delete the comment', :js do
    it 'deletes the comment' do
      visit group_talk_path(group, talk)
      expect(page).to have_text(comments[1].description)
      within("#comment_#{comments[1].id}") do
        expect(page).to have_text('削除する')
        page.accept_confirm 'コメントを削除します。よろしいですか？' do
          click_on '削除する', match: :first
        end
      end
      expect(page).to have_content(comments[0].description)
      expect(page).to have_no_content(comments[1].description)
      expect(page).to have_content("コメント （#{talk.reload.comments.size}）")
    end
  end

  describe 'converts text to braille in the form', :js do
    context 'when clicking the convert button in the new form' do
      it 'converts to raised braille and indented braille' do
        visit group_talk_path(group, talk)
        within("#new_comment") do
          fill_in '点字クイズにする言葉をひらがなで入力', with: 'こんにちわ'
          click_button '点字を確認する'
        end

        expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
        expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
      end
    end

    context 'when clicking the convert button in the first comment' do
      it 'converts to raised braille and indented braillein the first comment' do
        visit group_talk_path(group, talk)
        within("#comment_#{comments[0].id}") do
          click_on '編集する'
        end

        within(".edit_comment") do
          fill_in '点字クイズにする言葉をひらがなで入力', with: 'こんにちわ'
          click_button '点字を確認する'

          expect(page).to have_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
          expect(page).to have_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
        end
      end

      it "does not convert the text in other comments" do
        visit group_talk_path(group, talk)
        within("#comment_#{comments[0].id}") do
          click_on '編集する'
        end

        within(".edit_comment") do
          fill_in '点字クイズにする言葉をひらがなで入力', with: 'こんにちわ'
          click_button '点字を確認する'
        end

        within("#comment_#{comments[2].id}") do
          expect(page).to have_no_css('span[data-braille-converter-target="raised"]', text: '⠪⠴⠇⠗⠄')
          expect(page).to have_no_css('span[data-braille-converter-target="indented"]', text: '⠠⠺⠸⠦⠕')
        end
      end
    end
  end

  describe 'a braille quiz is provided with a button to reveal the correct answer', :js do
    it 'can reveal the correct hiragana for the braille quiz', :js do
      braille = create(:braille, user:)
      comments[0].update!(braille:)
      visit group_talk_path(group, talk)

      within "#comment_#{comments[0].id}" do
        expect(page).to have_content ("#{braille.raised_braille}")
        expect(page).to have_content ("#{braille.indented_braille}")
        expect(page).to have_css('.comment_original_text.hidden', visible: :all)

        click_on '正解を見る'
        expect(page).to have_content ("#{braille.original_text}")
      end
    end

    it 'hides the correct hiragana when the button is pressed', :js do
      braille = create(:braille, user:)
      comments[0].update!(braille:)
      visit group_talk_path(group, talk)
      within "#comment_#{comments[0].id}" do
        click_on '正解を見る'
        expect(page).to have_content '正解をかくす'
        click_on '正解をかくす'
        expect(page).to have_css('.comment_original_text.hidden', visible: :all)
      end
    end
  end

  describe 'collapse comments', :js do
    it 'displays initial comments and recent_comments' do
      additional_comments = create_list(:comment, 20, talk:, user:) # rubocop:disable FactoryBot/ExcessiveCreateList
      visit group_talk_path(group, talk)
      all_comments = comments + additional_comments
      count = Comment::INITIAL_DISPLAY_COUNT
      remaining_comments = all_comments.dup
      initial_comments = remaining_comments.slice!(0, count)
      recent_comments = remaining_comments.slice!(-count, count)
      hidden_comments = remaining_comments

      expect(page).to have_content "コメント （#{all_comments.size}）"
      expect(page).to have_content "コメントをさらに表示 (残り#{all_comments.size - count*2}件)"
      initial_comments.each do |comment|
        expect(page).to have_content(comment.description)
      end
      hidden_comments.each do |comment|
        expect(page).to have_no_content(comment.description)
      end
      recent_comments.each do |comment|
        expect(page).to have_content(comment.description)
      end
    end

    it 'displays a few more comments each time the button is clicked' do
      additional_comments = create_list(:comment, 20, talk:, user:) # rubocop:disable FactoryBot/ExcessiveCreateList
      visit group_talk_path(group, talk)
      all_comments = comments + additional_comments
      count = Comment::INITIAL_DISPLAY_COUNT
      remaining_comments = all_comments.dup
      remaining_comments.slice!(0, count)
      remaining_comments.slice!(-count, count)
      hidden_comments = remaining_comments
      hidden_count = hidden_comments.size
      pp hidden_count

      hidden_comments.each_slice(Comment::INCREMENT_SIZE) do |next_comments|
        return if hidden_count <= 0

        click_on "コメントをさらに表示 (残り#{hidden_count}件)"
        next_comments.each do |comment|
          expect(page).to have_content(comment.description)
        end
        pp hidden_count
        hidden_count -= Comment::INCREMENT_SIZE
        pp hidden_count
      end
      expect(page).to have_no_content('コメントをさらに表示')
    end
  end
end
