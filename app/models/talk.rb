class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments
  has_many :subscriptions
  has_one :braille, as: :brailleable

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
end
