class User < ApplicationRecord
  has_many :talks
  has_many :comments
  has_many :subscriptions
  has_many :group_menberships
end
