class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments
  has_many :subscriptions
  has_many :group_menberships
  has_one :braille, as: :brailleable
end
