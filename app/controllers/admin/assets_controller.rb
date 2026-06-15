class Admin::AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end

  def show
    @asset = Asset.find(params[:id])
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to admin_assets_path, notice: "固定資産を削除しました。"
  end
end
