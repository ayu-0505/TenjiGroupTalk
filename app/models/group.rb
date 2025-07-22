class Group < ApplicationRecord
  has_many :talks
  has_many :memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  validates :name, presence: true, length: { maximum: 100 }
end
