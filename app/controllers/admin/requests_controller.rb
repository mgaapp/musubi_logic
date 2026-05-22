class Admin::RequestsController < ApplicationController
  def index
    @requests = Request.all.order(created_at: :desc)
  end

  def show
    @request = Request.find(params[:id])
  end
  
  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
    redirect_to admin_request_path(@request), notice: "申請のステータスを更新しました。"
    else
    render :show, status: :unprocessable_entity
    end
 end

 private
 def request_params
    params.require(:request).permit(:status)
  end
end

