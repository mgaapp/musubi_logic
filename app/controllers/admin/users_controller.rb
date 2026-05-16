class Admin::UsersController < ApplicationController
  before_action :authenticate_admin
  def index
    @users = User.all
  end

  def authenticate_admin
    if !authenticated? || !Current.user.admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end
end