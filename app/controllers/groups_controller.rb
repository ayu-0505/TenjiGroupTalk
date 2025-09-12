class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :authorize_group_member, only: %i[ show edit update destroy ]

  # GET /groups or /groups.json
  def index
    # TODO: 開発のしやすさを考慮し、一時的にall取得にしている。最終は下コードにすること
    @groups = Group.all
    # @groups = current_user.groups
  end

  # GET /groups/1 or /groups/1.json
  def show
    @memberships = @group.memberships
    @membership = @memberships.find_by(user: current_user)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)
    @group.admin = current_user
    @group.users << current_user

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'グループを作成しました' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'グループを更新しました' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to groups_path, status: :see_other, notice: 'グループを削除しました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.expect(group: [ :name ])
    end

    def authorize_group_member
      return if current_user.member_of?(@group)

      redirect_back_or_to dashboard_path, status: :see_other, alert: 'この操作を行うには、グループのメンバーである必要があります'
    end
end
