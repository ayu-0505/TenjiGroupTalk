class Group < ApplicationRecord
  has_many :talks
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :invitations, dependent: :destroy
  belongs_to :admin, class_name: 'User'

  validates :name, presence: true, length: { maximum: 50 }

  def member_count
    users.count
  end

  def last_invitation
    invitations
      .where('expires_at > ?', Time.current)
      .order(expires_at: :desc)
      .first
  end
end
