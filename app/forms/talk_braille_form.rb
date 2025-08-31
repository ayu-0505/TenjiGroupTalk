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
      @talk = Talk.create!(
        title: title,
        description: description,
        user: @user,
        group: @group
      )

      if original_text.present?
        @talk.create_braille!(
          original_text: original_text,
          user: @user
        )
      end
    true
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    false
  end

  def update
    return false if invalid?

    ActiveRecord::Base.transaction do
      @talk.update!(
       {
         title: title,
         description: description
       }
      )

      # ひらがな（original_text）がない場合は既存の点字（brailleモデル）の有無を確認し、あれば削除
      if original_text.blank?
        @talk.braille.destroy! if @talk.braille.present?

      # ひらがな（original_text）に入力があり、既存の点字がない場合は点字を新規作成
      elsif @talk.braille.nil?
        @talk.create_braille!(
          original_text: original_text,
          user: @user
        )

      # 入力されたひらがなが、既存の点字内容と違う場合、既存点字を破棄して新規作成
      elsif !@talk.braille.same_content?(original_text:)
        @talk.braille.destroy!
         @talk.create_braille!(
          original_text: original_text,
          user: @user
        )
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
