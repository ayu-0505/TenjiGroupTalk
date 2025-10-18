class CommentBrailleForm
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :description, :string
  attribute :original_text, :string

  attr_reader :comment

  validates :description, presence: true

  def initialize(user: nil, talk: nil, comment: Comment.new, attributes: nil)
    @user ||= user
    @talk ||= talk
    @comment = comment
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      if original_text.present?
        braille = @user.brailles.create!(original_text: original_text)
      end

      @comment = @user.comments.create!(
        description: description,
        talk: @talk,
        braille:
      )
    true
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def update
    return false if invalid?

    ActiveRecord::Base.transaction do
      existing_braille = @comment.braille
      # ひらがな（original_text）入力がない場合は既存の点字（brailleモデル）の有無を確認し、あれば削除
      if original_text.blank?
        existing_braille.destroy! if existing_braille.present?
        @comment.update!({ description: description })

      # ひらがな（original_text）入力があり、既存の点字がない場合は点字を新規作成
      elsif existing_braille.nil?
        braille = @user.brailles.create!(original_text:)
        @comment.update!({ description: description, braille: })

      # 入力されたひらがなが、既存の点字内容と違う場合、既存点字を更新
      else !existing_braille.same_content?(original_text)
        existing_braille.update!(
          original_text:,
        )
        @comment.update!({ description: description })
      end
      true
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def form_with_options
    if @comment.persisted?
      { url: Rails.application.routes.url_helpers.talk_comment_path(@talk, @comment), method: :patch }
    else
      { url: Rails.application.routes.url_helpers.talk_comments_path(@talk), method: :post }
    end
  end

  private

  def default_attributes
    if @comment.braille.nil?
      {
        description: @comment.description
      }
    else
      {
        description: @comment.description,
        original_text: @comment.braille.original_text
      }
    end
  end
end
