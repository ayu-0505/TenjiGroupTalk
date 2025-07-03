class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments
  has_many :subscriptions
end
