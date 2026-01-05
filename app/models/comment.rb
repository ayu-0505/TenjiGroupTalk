class Comment < ApplicationRecord
  INITIAL_DISPLAY_COUNT = 5

  belongs_to :user
  belongs_to :talk, counter_cache: true
  belongs_to :braille, optional: true
  has_many :notifications, dependent: :destroy

  validates :description, presence: true

  scope :displayed, -> { order(created_at: :desc).limit(INITIAL_DISPLAY_COUNT).reverse }
  scope :hidden, -> { order(created_at: :desc).offset(INITIAL_DISPLAY_COUNT).reverse }
end
