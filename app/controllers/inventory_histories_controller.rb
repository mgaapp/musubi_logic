class InventoryHistoriesController < ApplicationController
  # ログインしていないユーザーのアクセスを制限
  before_action :authenticated?

  #　システム全体の在庫操作履歴を取得して一覧表示する
  def index
    # 履歴を最新順で取得し、ページネーション処理を適用
    @inventory_histories = InventoryHistory.includes(inventory: { request: :category })
                                           .order(created_at: :desc)
                                           .page(params[:page])
  end
end
