class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  belongs_to :braille, optional: true
  has_many :notifications, dependent: :destroy

  validates :description, presence: true
end
