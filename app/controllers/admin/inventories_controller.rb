class Admin::InventoriesController < ApplicationController
  before_action :admin_user

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    @inventory.status = "在庫あり"
    if @inventory.save
      redirect_to admin_inventories_path, notice: "貯蔵品を新しく登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @inventories = Inventory.includes(request: :category).order(stock_quantity: :desc, created_at: :desc)

    if params[:location].present?
      @inventories = @inventories.where(location: params[:location])
    end

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"

      @inventories = @inventories.left_outer_joins(request: :category).where(
        "inventories.location LIKE ? OR inventories.vendor LIKE ? OR categories.name LIKE ?",
        keyword, keyword, keyword
      )
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data generate_csv(@inventories), filename: "inventories-#{Date.today}.csv", type: "text/csv; charset=utf-8"
      end
    end
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    @inventory = Inventory.find(params[:id])

    if params[:checkout] == "true"
      if @inventory.stock_quantity <= 0
        redirect_to admin_inventories_path, alert: "在庫がないため、これ以上使用できません。" and return
      end

      new_stock = @inventory.stock_quantity - 1
      new_status = new_stock == 0 ? "在庫なし" : "在庫あり"

      if @inventory.update(stock_quantity: new_stock, status: new_status)
        InventoryHistory.create!(inventory_id: @inventory.id, user_id: Current.user.id, quantity: 1, status: :out)
        redirect_to admin_inventories_path, notice: "貯蔵品を1個使用しました。" and return
      end
    end

    new_quantity = inventory_params[:stock_quantity].to_i
    old_quantity = @inventory.stock_quantity.to_i
    if @inventory.update(inventory_params)
      InventoryHistory.create!(inventory_id: @inventory.id, user_id: Current.user.id, quantity: (new_quantity - old_quantity).abs, status: :fix)
      redirect_to admin_inventories_path, notice: "貯蔵品の個数を修正しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def inventory_params
    params.require(:inventory).permit(:request_id, :location, :unit_price_excl_tax, :stock_quantity, :vendor, :purchase_date, :status, :name)
  end

  def generate_csv(inventories)
    require 'csv'

    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << ["貯蔵品ID", "品名", "拠点", "購入先", "税抜単価", "現在の個数", "ステータス"]

      inventories.each do |inventory|
        name = inventory.request.present? ? inventory.request.category&.name : inventory.name
        csv << [
          inventory.id,
          name,
          inventory.location,
          inventory.vendor,
          inventory.unit_price_excl_tax,
          inventory.stock_quantity,
          inventory.status
        ]
      end
    end
  end
end
