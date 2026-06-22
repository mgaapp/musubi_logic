class InventoriesController < ApplicationController
  def index
    @inventories = Inventory.includes(request: :category).all

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      
      @inventories = @inventories.eager_load(request: :category)
                                 .where(
                                   "inventories.location LIKE ? OR requests.vendor LIKE ? OR categories.name LIKE ?", 
                                   keyword, keyword, keyword
                                 )
                                 .references(:request, :category)
    end
  end
end
