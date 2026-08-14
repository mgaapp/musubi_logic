class Admin::AssetsController < ApplicationController
  def index
    @assets = Asset.includes(request: :category).all

    respond_to do |format|
      format.html
      format.csv do
        send_data generate_csv(@assets), filename: "assets-#{Date.today}.csv", type: "text/csv; charset=utf-8"
      end
    end
  end

  def show
    @asset = Asset.find(params[:id])
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to admin_assets_path, notice: "固定資産を削除しました。"
  end

  private

  def generate_csv(assets)
    require 'csv'

    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << ["資産ID", "品名", "拠点名", "取得金額（税抜）", "耐用年数", "償却方法", "供用開始日", "償却終了予定日", "購入先", "購入日", "状態"]

      assets.each do |asset|
        csv << [
          asset.id,
          asset.request&.category&.name,
          asset.location,
          asset.acquisition_cost_excl,
          asset.useful_life_years,
          asset.depreciation_method,
          asset.service_start_date,
          asset.depreciation_end_date,
          asset.vendor,
          asset.purchase_date,
          asset.status
        ]
      end
    end
  end
end
