class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  has_one :braille, as: :brailleable
  has_many :notifications, as: :notifiable
end
