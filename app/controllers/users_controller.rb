class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
    @groups = @user.groups.preload(:talks, :users, :admin).order(created_at: :desc)
  end

  private
    def set_user
      @user = User.find(params.expect(:id))
    end
end
