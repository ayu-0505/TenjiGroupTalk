class Group < ApplicationRecord
  has_many :talks
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  belongs_to :admin, class_name: 'User'

  validates :name, presence: true, length: { maximum: 50 }

  def member_count
    users.count
  end
end
