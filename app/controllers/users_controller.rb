class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'ニックネームを更新しました'
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
      @user = User.find(params.expect(:id))
    end

    def user_params
      params.expect(user: [ :nickname ])
    end
end
