class RequestsController < ApplicationController

  def index
    @requests = Current.user.requests.order(created_at: :desc).page(params[:page])
  end

  def show
    @request = Current.user.requests.find_by(id: params[:id])
   if @request
   else
    redirect_to requests_path, alert: "アクセス権限がありません。"
   end
  end

  def new
    @request = Request.new
  end

  def create
    @request = Current.user.requests.new(request_params)

    price = @request.unit_price_excl_tax || 0
    quantity = @request.quantity || 0
    tax_rate = @request.tax_rate || 0

    @request.total_amount_incl_tax = (price * quantity * (1 + tax_rate / 100.0)).floor
    
    if @request.save
      redirect_to requests_path, notice: "経費申請を提出しました。"  
    else
    render :new, status: :unprocessable_entity
  end 
end

private

def request_params
    params.require(:request).permit(:category_id, :total_amount_incl_tax, :unit_price_excl_tax, :tax_rate, :quantity, :vendor, :receipt_url, :status, :applied_at, :image)
  end
end