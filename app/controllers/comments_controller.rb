class CommentsController < ApplicationController
  before_action :set_group_and_talk, only: %i[ edit create update destroy ]
  before_action :set_comment, only: %i[ edit update destroy ]

  # TODO: 一部でHotwire使用のため、noticeが意図通り動かない。flashに変更後、turbo_streamを使って同時更新を行うこと

  def edit
  end

  # POST /comments or /comments.json
  def create
    comment = @talk.comments.build(comment_params)
    comment.user = current_user

    respond_to do |format|
      if comment.save
        format.html { redirect_to group_talk_path(@group, @talk), notice: 'コメントを投稿しました！' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to group_talk_path(@group, @talk), flash: { error: comment.errors.full_messages } }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to group_talk_path(@group, @talk), notice: 'コメントが更新されました！' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    def set_group_and_talk
      @group = current_user.groups.find(params.expect(:group_id))
      @talk = @group.talks.find(params.expect(:talk_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = current_user.comments.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :description ])
    end
end
