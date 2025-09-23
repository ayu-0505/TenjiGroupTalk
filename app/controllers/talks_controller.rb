class TalksController < ApplicationController
  before_action :set_group
  before_action :set_talk, only: %i[ show edit update destroy ]
  before_action :authorize_owner, only: %i[ edit update destroy ]

  # GET /talks or /talks.json
  def index
    @talks = @group.talks.order(created_at: :desc)
  end

  # GET /talks/1 or /talks/1.json
  def show
    @comments = @talk.comments
    @comment_form = CommentBrailleForm.new(talk: @talk)
  end

  # GET /talks/new
  def new
    @talk_form = TalkBrailleForm.new(group: @group)
  end

  # GET /talks/1/edit
  def edit
    @talk_form = TalkBrailleForm.new(group: @group, talk: @talk)
  end

  # POST /talks or /talks.json
  def create
    @talk_form = TalkBrailleForm.new(user: current_user, group: @group, attributes: talk_braille_params)

    respond_to do |format|
      if @talk_form.save
        ActiveSupport::Notifications.instrument('talk.create', user: current_user, talk: @talk_form.talk)

        format.html { redirect_to group_talk_path(@group, @talk_form.talk), notice: 'トークが作成されました！' }
        format.json { render :show, status: :created, location: @talk }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @talk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /talks/1 or /talks/1.json
  def update
    @talk_form = TalkBrailleForm.new(user: current_user, group: @group, talk: @talk, attributes: talk_braille_params)
    respond_to do |format|
      if @talk_form.update
        format.html { redirect_to group_talk_path(@group, @talk), notice: 'トークを更新しました！' }
        format.json { render :show, status: :ok, location: @talk }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @talk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /talks/1 or /talks/1.json
  def destroy
    @talk.destroy!

    respond_to do |format|
      format.html { redirect_to group_talks_path(@group), status: :see_other, notice: 'トークは削除されました' }
      format.json { head :no_content }
    end
  end

  private
    def set_group
      @group = current_user.groups.find(params.expect(:group_id))
    end
    # Use callbacks to share common setup or constraints between actions.
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
