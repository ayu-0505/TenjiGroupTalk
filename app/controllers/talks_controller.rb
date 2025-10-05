class TalksController < ApplicationController
  before_action :set_group
  before_action :set_talk, only: %i[ show edit update destroy ]
  before_action :authorize_owner, only: %i[ edit update destroy ]

  def index
    @talks = @group.talks.order(created_at: :desc)
  end

  def show
    @comments = @talk.comments
    @comment_form = CommentBrailleForm.new(talk: @talk)
  end

  def new
    @talk_form = TalkBrailleForm.new(group: @group)
  end

  def edit
    @talk_form = TalkBrailleForm.new(group: @group, talk: @talk)
  end

  def create
    @talk_form = TalkBrailleForm.new(user: current_user, group: @group, attributes: talk_braille_params)

    if @talk_form.save
      ActiveSupport::Notifications.instrument('talk.create', user: current_user, talk: @talk_form.talk)
      redirect_to group_talk_path(@group, @talk_form.talk), notice: 'トークが作成されました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @talk_form = TalkBrailleForm.new(user: current_user, group: @group, talk: @talk, attributes: talk_braille_params)

    if @talk_form.update
      redirect_to group_talk_path(@group, @talk), notice: 'トークを更新しました！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @talk.destroy!

    redirect_to group_talks_path(@group), status: :see_other, notice: 'トークは削除されました'
  end

  private
    def set_group
      @group = current_user.groups.find(params.expect(:group_id))
    end

    def set_talk
      @talk = @group.talks.find(params.expect(:id))
    end

    def authorize_owner
      return if @talk.user == current_user

      redirect_back_or_to dashboard_path, alert: 'この操作はトーク作成者のみ可能です'
    end

    def talk_braille_params
      params.expect(talk_braille_form: [ :title, :description, :original_text ])
    end
end
