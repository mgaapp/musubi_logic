class InventoryHistoriesController < ApplicationController

    def create
      inventory = Inventory.find(params[:inventory_id])

      inventory.stock_quantity -= 1
      inventory.save

      redirect_to inventories_path, notice: "在庫を１個使用しました。"
    end
end
