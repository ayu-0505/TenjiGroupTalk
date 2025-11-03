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
    it 'updates the user with valid nickname' do
      visit user_path(user)
      click_on '編集'
      fill_in 'user_nickname', with: '新しいニックネーム'
      click_on '更新'
      expect(page).to have_content '新しいニックネーム'
    end

    it 'does not save when nickname is blank', :js do
      visit user_path(user)
      click_on '編集'
      fill_in 'user_nickname', with: '       '
      click_on '更新'
      expect(page).to have_content 'ニックネーム編集'
      click_on 'プロフィールへ戻る'
      expect(page).to have_content user.display_name
    end
  end
end
