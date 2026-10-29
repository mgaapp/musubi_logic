class UsersController < ApplicationController
  # ログイン中ユーザーのプロフィール情報や各種申請履歴などを表示
  def show
    # ログインユーザー情報を取得
    @user = Current.user
  end
end
