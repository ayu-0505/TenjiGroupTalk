module GroupsHelper
  def invitation_text(invitation)
    <<~TEXT
      点字をひたすら使って覚える掲示板、点字グループトーク！

      ひとこと点字を送ることができる掲示板サービスです
      しりとり？クイズ？ミニ日記？点字に変換する内容はなんでもOK
      色々な言葉を点字変換して送り合い、どんどん点字を覚えよう！

      招待URL
      #{welcome_url(invitation_token: invitation.token)}
    TEXT
  end
end
