class HomesController < ApplicationController
  # トップページのみ未ログイン状態でもアクセスを許可
  allow_unauthenticated_access only: [:top]

  # サービス概要やログインへの導線を表示する未認証ユーザー向けページ
  def top
  end

  # ログイン状態および管理者権限を検証
  def admin_user
    if !authenticated? || Current.user&.role != "admin"
      redirect_to root_path, alert: "管理者専用のページです。"
    end
  end
end
