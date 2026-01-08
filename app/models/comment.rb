class Comment < ApplicationRecord
  INITIAL_DISPLAY_COUNT = 5
  INCREMENT_SIZE = 10

  belongs_to :user
  belongs_to :talk, counter_cache: true
  belongs_to :braille, optional: true
  has_many :notifications, dependent: :destroy

  validates :description, presence: true
end
