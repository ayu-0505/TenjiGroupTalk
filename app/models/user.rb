class User < ApplicationRecord
  has_many :talks
  has_many :comments
  has_many :subscriptions
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      user_params = user_params_from_auth_hash(auth_hash)
      find_or_create_by(uid: user_params[:uid]) do |user|
        user.update(user_params)
      end
    end

    private

    def user_params_from_auth_hash(auth_hash)
      {
        name: auth_hash.info.name,
        email: auth_hash.info.email,
        uid: auth_hash.uid,
        image: auth_hash.info.image
      }
    end
  end
end
