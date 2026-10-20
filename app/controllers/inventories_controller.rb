class InventoriesController < ApplicationController
  #在庫一覧表示・検索
  def index
    # 在庫数、作成日時を降順でソート
    @inventories = Inventory.includes(request: :category).order(stock_quantity: :desc, created_at: :desc)

    # 検索キーワードが存在する場合の絞り込み処理
    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      #保管場所・購入先・カテゴリ名から部分一致検索
      @inventories = @inventories.left_outer_joins(request: :category).where(
        "inventories.location LIKE ? OR inventories.vendor LIKE ? OR categories.name LIKE ?",
        keyword, keyword, keyword
      )
    end
  end
end
