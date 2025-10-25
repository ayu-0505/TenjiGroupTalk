class CommentsController < ApplicationController
  before_action :set_talk, only: %i[ edit create update destroy ]
  before_action :set_comment, only: %i[ edit update destroy ]
  before_action :authorize_group_member

  def edit
    @comment_form = CommentBrailleForm.new(talk: @talk, comment: @comment)
  end

  def create
    @comment_form = CommentBrailleForm.new(user: current_user, talk: @talk, attributes: comment_braille_params)

    respond_to do |format|
      if @comment_form.save
        ActiveSupport::Notifications.instrument('comment.create', user: current_user, talk: @talk, comment: @comment_form.comment)
        format.html { redirect_to group_talk_path(@talk.group, @talk), notice: 'コメントを投稿しました！' }
        format.turbo_stream {
          flash.now[:notice] = 'コメントを投稿しました！'
          render :create, locals: { success: true }
        }
      else
        format.turbo_stream { render :create, locals: { success: false, comment_form: @comment_form }, status: :unprocessable_entity }
        format.html { redirect_to group_talk_path(@talk.group, @talk), flash: { error: @comment_form.errors.full_messages } }
      end
    end
  end

  def update
    @comment_form = CommentBrailleForm.new(user: current_user, talk: @talk, comment: @comment, attributes: comment_braille_params)
    respond_to do |format|
      if @comment_form.update
        format.html { redirect_to group_talk_path(@talk.group, @talk), notice: 'コメントが更新されました！' }
        format.turbo_stream { flash.now[:notice] = 'コメントが更新されました！' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy!
    @talk.reload

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = 'コメントを削除しました' }
    end
  end

  private
    def set_talk
      @talk = Talk.find(params.expect(:talk_id))
    end

    def set_comment
      @comment = current_user.comments.find(params.expect(:id))
    end

    def comment_braille_params
      params.expect(comment_braille_form: [ :description, :original_text ])
    end

    def authorize_group_member
      return if current_user.groups.include?(@talk.group)

      head :not_found
    end
end
