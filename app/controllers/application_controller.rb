class ApplicationController < ActionController::Base
  include Authentication
  #主要ブラウザからのアクセスのみ許可
  allow_browser versions: :modern
  #全アクションの実行前にユーザーのログイン認証を強制
  before_action :require_authentication

  #ログイン成功後に遷移するデフォルトのパスを定義
  def after_sign_in_path_for(resource)
    root_path
  end

  # ログインユーザーが管理者でなければトップページに弾く
  def admin_user
    if Current.user&.role != "admin"
      redirect_to root_path, alert: "管理者専用のページです。"
    end
  end
end


