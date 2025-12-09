require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  before do
    user.groups << group
    log_in_as user
  end

  describe 'show the user' do
    it 'displays the user' do
      visit user_path(user)
      expect(page).to have_content user.display_name
      user.groups.each do |group|
        expect(page).to have_content group.name
      end
    end
  end

  describe 'update the user' do
    it 'updates the user with valid nickname', :js do
      visit user_path(user)
      click_on 'ネームを変更する'
      fill_in 'ネームを入力してください', with: '新しいニックネーム'
      click_on 'ネームを更新する'
      expect(page).to have_content '新しいニックネーム'
    end

    it 'does not save when nickname is blank', :js do
      visit user_path(user)
      click_on 'ネームを変更する'
      fill_in 'user_nickname', with: '       '
      expect(page).to have_button('ネームを更新する', disabled: true)
      expect(page).to have_content 'ネームを変更する'
      click_on 'プロフィールへ戻る'
      expect(page).to have_content user.display_name
    end
  end
end
