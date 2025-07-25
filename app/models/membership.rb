class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # TODO: 招待制のため、招待リンクの機能を作成してからこのバリデーションに関するテストを作成すること
  validates :user_id, presence: true, uniqueness: { scope: :group_id, message: '同じグループに２重でメンバーになることはできません。' }
end
