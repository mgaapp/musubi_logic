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
    
      if @request.status == "承認" && @request.category&.name == "貯蔵品"
        Inventory.create!(request_id: @request.id,location: "本社",vendor: "申請データより自動生成",unit_price_excl_tax: 1000,stock_quantity: 1,purchase_date: Date.today,status: "保管中")

      redirect_to admin_requests_path, notice: "申請を承認し、貯蔵品棚卸表に反映しました！"
    elsif @request.status == "承認"
      redirect_to admin_requests_path, notice: "申請を承認しました。"
    else
      redirect_to admin_requests_path, notice: "申請を差し戻しました。"  
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

