class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :braille, optional: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
end
