class Admin::RequestsController < ApplicationController
  def show
    @request = Request.find(params[:id])
  end

  def index
    @requests = Request.all
    @requests = Request.page(params[:page]).per(5)
  end

  def update
    @request = Request.find(params[:id])

    if @request.update(request_params)
      if @request.status == "承認"
        if @request.category&.name == "貯蔵品"
          inventory = Inventory.create!(
            request_id: @request.id, 
            location: "本社"
            vendor: @request.vendor,                           
            unit_price_excl_tax: @request.unit_price_excl_tax, 
            stock_quantity: 1, 
            purchase_date: Date.today, 
            status: "在庫あり"                                  
          )
          
          InventoryHistory.create!(
            inventory_id: inventory.id, 
            user_id: Current.user.id, 
            quantity: 1, 
            status: :fix
          )
          @notice_message = "申請を承認し、貯蔵品棚卸表に反映しました！"

        elsif @request.unit_price_excl_tax >= 100000
          
          Asset.create!(
            request_id: @request.id, 
            location: "本社", 
            acquisition_cost_excl: @request.unit_price_excl_tax, 
            useful_life_years: 4, 
            depreciation_method: "定額法", 
            service_start_date: Date.today, 
            vendor: @request.vendor, 
            purchase_date: Date.today, 
            status: "稼働中"
          )
          @notice_message = "申請を承認し、10万円以上のマスタとして固定資産台帳に自動登録しました！"

        else
          @notice_message = "申請を承認しました。"
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

