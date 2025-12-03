require 'rails_helper'

RSpec.describe "Groups", type: :system do
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe 'Actions available only to group members' do
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
    it 'shows the list of members' do
      members = create_list(:user, 5)
       members.each { |member| member.groups << group }
      user.groups << group

      log_in_as user
      visit group_path(group)
      expect(page).to have_content(user.display_name)
      members.each do |member|
        expect(page).to have_content(member.display_name)
      end
    end

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
        click_button 'メッセージを作成'
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
