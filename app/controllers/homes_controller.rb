class HomesController < ApplicationController
  allow_unauthenticated_access only: [:top]

  def top
  end

  def admin_user
    if !authenticated? || Current.user&.role != "admin"
      redirect_to root_path, alert: "管理者専用のページです。"
    end
  end
end
