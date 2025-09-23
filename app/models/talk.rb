class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_one :braille, as: :brailleable, dependent: :destroy
  accepts_nested_attributes_for :braille, allow_destroy: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
end
