require 'rails_helper'

RSpec.describe "Groups", type: :system do
  let(:group) { create(:group) }

  describe 'Actions available only to group members' do
    let(:user) { create(:user) }

    before do
      log_in_as user
    end

    context 'when a non-member user accesses' do
      it 'is prevented' do
        visit group_path(group)
        expect(page).to have_content 'この操作を行うには、グループのメンバーである必要があります'

        visit edit_group_path(group)
        expect(page).to have_content 'この操作を行うには、グループのメンバーである必要があります'
      end
    end
  end

  describe 'group page' do
    context 'when the admin user' do
      before do
        group.admin.groups << group
        log_in_as group.admin
      end

      it 'prevents the user from leaving the group' do
        visit group_path(group)
        click_button 'グループから抜ける'
        expect(page).to have_content '管理者はグループを抜けられません。グループ削除を行なってください。'
      end

      it 'creates an invitation URL when the create button is clicked' do
        visit group_path(group)
        click_button '招待URLを作成'
        expect(page).to have_content "http://www.example.com/welcome?invitation_token=#{Invitation.last.token}"
      end

      it 'deletes the group when the user confirms deletion', :js do
        visit group_path(group)
        click_button 'グループを削除する'
        expect(page.accept_confirm).to eq 'グループを削除すると今までのトークとコメントのデータが全て削除されます。この操作は元に戻すことができません。本当によろしいですか？'
        expect(page).to have_content 'グループを削除しました'
        expect(Group.all.include?(group)).to be false
      end

      it 'keeps the group when the user cancels deletion', :js do
        visit group_path(group)
        click_button 'グループを削除する'
        expect(page.dismiss_confirm).to eq 'グループを削除すると今までのトークとコメントのデータが全て削除されます。この操作は元に戻すことができません。本当によろしいですか？'
        expect(Group.all.include?(group)).to be true
      end
    end
  end
end
