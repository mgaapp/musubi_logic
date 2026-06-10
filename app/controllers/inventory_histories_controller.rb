class InventoryHistoriesController < ApplicationController
  before_action :authenticate_user!

    def create
      inventory = Inventory.find(params[:inventory_id])

      inventory.stock_quantity -= 1
      inventory.save

      InventoryHistory.create(inventory_id: inventory.id, user_id: current_user.id, quantity: 1, status: :out)

      redirect_to inventories_path, notice: "在庫を１個使用しました。"
    end

    def index
      @inventory_histories = current_user.inventory_histories.order("created_at DESC")
    end
end
