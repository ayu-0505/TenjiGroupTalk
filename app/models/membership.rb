class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user_id, presence: true, uniqueness: { scope: :group_id, message: '同じグループに２重でメンバーになることはできません。' }
end
