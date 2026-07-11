class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  before_action :require_authentication

  def after_sign_in_path_for(resource)
    root_path
  end

  def admin_user
    if Current.user&.role != "admin"
      redirect_to root_path, alert: "管理者専用のページです。"
    end
  end
end
