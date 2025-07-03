class User < ApplicationRecord
  has_many :talks
  has_many :comments
  has_many :subscriptions
end
