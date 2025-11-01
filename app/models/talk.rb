class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :braille, optional: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true

  scope :sort_by_latest_comments, -> {
    left_joins(:comments)
    .group('talks.id')
    .select('talks.*, MAX(COALESCE(comments.updated_at, talks.updated_at)) AS comments_updated_at')
    .reorder(Arel.sql('comments_updated_at DESC'))
    .order('comments_updated_at DESC')
  }
end
