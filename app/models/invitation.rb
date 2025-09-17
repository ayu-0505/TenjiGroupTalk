class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :group

  before_create :set_defaults

  def expired?
    expires_at.past?
  end

  private
  def set_defaults
    self.expires_at ||= 7.days.from_now
    self.token ||= SecureRandom.urlsafe_base64
  end
end
