class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]

  def index
    @groups = current_user.groups.preload(:talks).preload(:users).preload(:admin).order(created_at: :desc).page(params[:page])
  end

  def show
    @memberships = @group.memberships
    @membership = @memberships.find_by(user: current_user)
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.admin = current_user
    @group.users << current_user

    if @group.save
      redirect_to @group, notice: 'グループを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'グループを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy!

    redirect_to groups_path, status: :see_other, notice: 'グループを削除しました'
  end

  private
    def set_group
      @group = current_user.groups.find(params.expect(:id))
    end

    def group_params
      params.expect(group: [ :name ])
    end
end
