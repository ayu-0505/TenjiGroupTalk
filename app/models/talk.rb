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
    subquery = Comment.group('talk_id')
                      .select('talk_id, MAX(updated_at) AS latest_comment_time')

    joins("LEFT JOIN (#{subquery.to_sql}) AS latest_comments ON latest_comments.talk_id = talks.id")
    .select('talks.*, COALESCE(latest_comments.latest_comment_time, talks.updated_at) AS comments_updated_at')
    .order('comments_updated_at DESC')
  }
end
