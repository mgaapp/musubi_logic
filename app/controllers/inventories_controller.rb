class InventoriesController < ApplicationController
  def index
    @inventories = Inventory.includes(request: :category).order(stock_quantity: :desc, created_at: :desc)

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @inventories = @inventories.joins(request: :category).where(
        "inventories.location LIKE ? OR inventories.vendor LIKE ? OR categories.name LIKE ?", 
        keyword, keyword, keyword
      )
    end
  end
end