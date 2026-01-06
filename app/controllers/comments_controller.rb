class CommentsController < ApplicationController
  before_action :set_talk, only: %i[ edit create update destroy ]
  before_action :set_comment, only: %i[ edit update destroy ]

  def edit
    @comment_form = CommentBrailleForm.new(talk: @talk, comment: @comment)
  end

  def create
    @comment_form = CommentBrailleForm.new(user: current_user, talk: @talk, attributes: comment_braille_params)

    if @comment_form.save
      ActiveSupport::Notifications.instrument('comment.create', user: current_user, talk: @talk, comment: @comment_form.comment)
      flash.now[:notice] = 'コメントを投稿しました！'
      render :create_success, formats: :turbo_stream
    else
      flash.now[:notice] = 'コメントが投稿できませんでした'
      render :create_false, formats: :turbo_stream, status: :unprocessable_entity
    end
  end

  def update
    @comment_form = CommentBrailleForm.new(user: current_user, talk: @talk, comment: @comment, attributes: comment_braille_params)
    if @comment_form.update
      flash.now[:notice] = 'コメントが更新されました！'
      render :update_success, formats: :turbo_stream
    else
      flash.now[:notice] = 'コメントが更新できませんでした'
      render :update_false, formats: :turbo_stream, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    @talk.reload

    flash.now[:notice] = 'コメントを削除しました'
  end

  private
    def set_talk
      @talk = Talk.joins(:group).where(group: { id: current_user.group_ids }).find(params.expect(:talk_id))
    end

    def set_comment
      @comment = @talk.comments.where(user: current_user).find(params.expect(:id))
    end

    def comment_braille_params
      params.expect(comment_braille_form: [ :description, :original_text ])
    end
end
