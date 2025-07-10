class Group < ApplicationRecord
  has_many :talks
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
end
