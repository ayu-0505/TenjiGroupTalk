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
     context 'when the admin user group leaves group' do
      before do
        group.admin.groups << group
        log_in_as group.admin
      end

      it 'prevents the user from leaving the group' do
        visit group_path(group)
        click_button 'グループから抜ける'
        expect(page).to have_content '管理者はグループを抜けられません。グループ削除を行なってください。'
      end
    end
  end
end
