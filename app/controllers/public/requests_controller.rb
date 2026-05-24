class Public::RequestsController < ApplicationController

  def index
    @requests = Current.user.requests
  end

  def show
    @request = Current.user.requests.find(params[:id])
  end

  def new
    @request = Request.new
  end

  def create
    @request = Current.user.requests.new(request_params)
    if @request.save
      redirect_to requests_path, notice: "経費申請を提出しました。"  
    else
    render :new, status: :unprocessable_entity
  end 
end

private

def request_params
    params.require(:request).permit(:category_id, :total_amount_incl_tax, :unit_price_excl_tax, :tax_rate, :quantity, :vendor, :receipt_url, :status, :applied_at)
  end
end