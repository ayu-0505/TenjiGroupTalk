require 'rails_helper'

RSpec.describe "Talks", type: :system do
  let(:talk) { create(:talk) }

  before do
    create(:membership, user: talk.user, group: talk.group)
    driven_by(:rack_test)
    log_in_as talk.user
  end

   describe 'user creates a new talk' do
     context 'when the user is logged in' do
       it 'creates a talk with valid input' do
        visit group_talks_path(talk.group)
        click_on '新しいトークを作成する'
        fill_in 'タイトル', with: '点字しりとり！'
        fill_in '内容', with: '点字を使ってしりとりしましょう'
        click_on 'トークを作成'

        expect(page).to have_content('トークが作成されました！')
        expect(page).to have_content('点字しりとり！')
        expect(page).to have_content('点字を使ってしりとりしましょう')
       end
     end
   end
end
