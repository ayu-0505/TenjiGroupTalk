require 'rails_helper'

RSpec.describe "Groups", type: :system do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  before do
    driven_by(:rack_test)
    log_in_as user
  end

    describe 'group page' do
     context 'when the group has only one member' do
      it 'prevents the user from leaving the group' do
        create(:membership, user: user, group: group)

        visit group_path(group)
        click_button 'グループから抜ける'
        expect(page).to have_content '最後のメンバーはグループを抜けられません。グループ削除を行なってください。'
      end
    end
  end
end
