class User < ApplicationRecord
  has_many :talks
  has_many :comments
  has_many :brailles
  has_many :subscriptions
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :invitations
  has_many :notifications, dependent: :destroy
  has_many :admin_groups, class_name: 'Group', foreign_key: :admin_id

  validates :nickname, format: { without: /\A\s*\z/, message: 'を入力してください' }, allow_nil: true

  def member_of?(group)
    groups.include?(group)
  end

  def soft_delete!
    update!(deleted_at: Time.current, name: 'deleted_name', email: 'deleted_email', uid: 'deleted_uid', image: 'deleted_image')
  end

  def deleted?
    deleted_at.present?
  end

  def self.find_or_initialize_from_auth_hash!(auth_hash)
    user_params = user_params_from_auth_hash(auth_hash)
    find_or_initialize_by(uid: user_params[:uid]) do |user|
      user.assign_attributes(user_params)
      user.nickname = user_params[:name]
    end
  end

  private

  def self.user_params_from_auth_hash(auth_hash)
    {
      name: auth_hash.info.name,
      email: auth_hash.info.email,
      uid: auth_hash.uid,
      image: auth_hash.info.image
    }
  end
end
