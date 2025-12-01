require 'rails_helper'

RSpec.describe GroupsHelper, type: :helper do
  let(:invitation) { create(:invitation) }

  describe '#invitation_text' do
    it 'returns invitation text' do
      result = <<~TEXT
        点字をひたすら使って覚える掲示板、点字グループトーク！

        ひとこと点字を送ることができる掲示板サービスです
        しりとり？クイズ？ミニ日記？点字に変換する内容はなんでもOK
        色々な言葉を点字変換して送り合い、どんどん点字を覚えよう！

        招待URL
        http://test.host/welcome?invitation_token=#{invitation.token}
      TEXT

      expect(invitation_text(invitation)).to eq result
    end
  end
end
