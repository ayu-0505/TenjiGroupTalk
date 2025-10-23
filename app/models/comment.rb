class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :talk, counter_cache: true
  belongs_to :braille, optional: true
  has_many :notifications, dependent: :destroy

  validates :description, presence: true
end
