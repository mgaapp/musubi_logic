class InventoriesController < ApplicationController
  def index
    @inventories = Inventory.joins(request: :category)
                            .select(
                              "categories.name AS category_name",
                              "inventories.location AS location",
                              "inventories.vendor AS vendor",
                              "MAX(inventories.unit_price_excl_tax) AS unit_price_excl_tax", 
                              "MAX(inventories.purchase_date) AS purchase_date",             
                              "SUM(inventories.stock_quantity) AS total_stock"             
                            )
                            .group("categories.name", "inventories.location", "inventories.vendor", "inventories.unit_price_excl_tax")

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @inventories = @inventories.where(
        "inventories.location LIKE ? OR inventories.vendor LIKE ? OR categories.name LIKE ?", 
        keyword, keyword, keyword
      )
    end
  end
end