class Admin::InventoryHistoriesController < ApplicationController
  # 管理者権限を持たない一般ユーザーのアクセスを制限
  before_action :admin_user

  # システム全体の全ユーザーによる在庫操作を一覧表示する
  def index
    # 最新順で取得し、ページネーションを適用
    @inventory_histories = InventoryHistory.includes(:user, inventory: { request: :category })
                                           .order(created_at: :desc)
                                           .page(params[:page])
  end
end
