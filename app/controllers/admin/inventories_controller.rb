class Admin::InventoriesController < ApplicationController
  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    if @inventory.save
     redirect_to inventories_path, notice: "貯蔵品を新しく登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @inventories = Inventory.all
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    @inventory = Inventory.find(params[:id])
    if @inventory.update(inventory_params)
     redirect_to admin_inventories_path, notice: "貯蔵品の個数を修正しました"
    else
      render :edit, :unprocessable_entity
    end
  end

  private

  def inventory_params
    params.require(:inventory).permit(:request_id, :location, :unit_price_excl_tax, :stock_quantity, :vendor, :purchase_date, :status)
  end
end