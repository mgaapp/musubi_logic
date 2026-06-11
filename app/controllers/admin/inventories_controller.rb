class Admin::InventoriesController < ApplicationController
  before_action :admin_user

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
    new_quantity = inventory_params[:stock_quantity].to_i
    old_quantity = @inventory.stock_quantity
    if @inventory.update(inventory_params)
      InventoryHistory.create!(inventory_id: @inventory.id, user_id:Current.user.id, quantity:(new_quantity - old_quantity).abs, status: :fix)
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