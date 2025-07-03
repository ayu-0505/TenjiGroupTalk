class User < ApplicationRecord
  has_many :talks
  has_many :comments
end
