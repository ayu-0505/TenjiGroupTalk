class TalkBrailleForm
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :description, :string
  attribute :original_text, :string

  attr_reader :talk

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true

  def initialize(user: nil, group: nil, talk: Talk.new, attributes: nil)
    @user ||= user
    @group ||= group
    @talk = talk
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      if original_text.present?
        braille = @user.brailles.create!(original_text:)
      end

      @talk = @user.talks.create!(
        title:,
        description:,
        group: @group,
        braille:
      )

      Subscription.find_or_create_by!(user: @user, talk: @talk)
    true
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def update
    return false if invalid?

    ActiveRecord::Base.transaction do
      existing_braille = @talk.braille

      # NOTE: ひらがな（original_text）入力がない場合は既存の点字（brailleモデル）の有無を確認し、あれば削除
      if original_text.blank?
        existing_braille.destroy! if existing_braille.present?
        @talk.update!({
          title:,
          description:
        })

      # NOTE: ひらがな（original_text）入力があり、既存の点字がない場合は点字を新規作成
      elsif existing_braille.nil?
        braille = @user.brailles.create!(original_text:)
        @talk.update!({
          title:,
          description:,
          braille:
        })

      # NOTE: 入力されたひらがなが、既存の点字内容と違う場合、既存点字を更新
      else !existing_braille.same_content?(original_text)
        existing_braille.update!(
          original_text:,
        )
        @talk.update!({
          title:,
          description:
        })
      end
      true
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def form_with_options
    if @talk.persisted?
      { url: Rails.application.routes.url_helpers.group_talk_path(@group, @talk), method: :patch }
    else
      { url: Rails.application.routes.url_helpers.group_talks_path(@group), method: :post }
    end
  end

  private
  def default_attributes
    if @talk.braille.nil?
      {
        title: @talk.title,
        description: @talk.description
      }
    else
      {
        title: @talk.title,
        description: @talk.description,
        original_text: @talk.braille.original_text
      }
    end
  end
end
