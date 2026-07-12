class Admin::UsersController < ApplicationController
  before_action :authenticate_admin
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "社員「#{@user.name}」さんを新規登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "社員「#{@user.name}」さんの情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "社員「#{@user.name}」さんを削除しました。"
  end

 private

  def authenticate_admin
    if Current.user.nil? || !Current.user.admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end

  def user_params
    params.require(:user).permit(:name, :employee_number, :email_address, :password, :password_confirmation, :role, :location)
  end
end
