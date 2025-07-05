class Braille < ApplicationRecord
  belongs_to :user
  belongs_to :brailleable, polymorphic: true
end
