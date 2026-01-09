class CurrentUsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'ニックネームを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.soft_delete!
    reset_session
    redirect_to root_path, status: :see_other, notice: '退会しました'
  end

  private
    def set_user
      @user = current_user
    end

    def user_params
      params.expect(user: [ :nickname ])
    end
end
