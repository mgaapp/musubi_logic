class Admin::RequestsController < ApplicationController
  def show
    @request = Request.find(params[:id])
  end

  def index
    @requests = Request.all
  end


  def update
    @request = Request.find(params[:id])

    if @request.update(request_params)
      if @request.status == "承認"
        
        if @request.category&.name == "貯蔵品"
          inventory = Inventory.create!(request_id: @request.id, location: "本社", vendor: "申請データより自動生成", unit_price_excl_tax: 1000, stock_quantity: 1, purchase_date: Date.today, status: "保管中")
          InventoryHistory.create!(inventory_id: inventory.id, user_id: Current.user.id, quantity: 1, status: :fix)
          @notice_message = "申請を承認し、貯蔵品棚卸表に反映しました！"
        else
          @notice_message = "申請を承認しました。"
        end

        if @request.unit_price_excl_tax >= 100000
          Asset.create!(request_id: @request.id, location: "本社", acquisition_cost_excl: @request.unit_price_excl_tax, useful_life_years: 4, depreciation_method: "定額法", service_start_date: Date.today, vendor: @request.vendor, purchase_date: Date.today, status: "稼働中")
          @notice_message = "（税抜10万円以上のため固定資産台帳にも自動登録しました）"
        end

        redirect_to admin_requests_path, notice: @notice_message

      else
        redirect_to admin_requests_path, notice: "申請を差戻ししました。"  
      end

    else
      render :show
    end
  end

  private

  def request_params
    params.require(:request).permit(:status)
  end
end

