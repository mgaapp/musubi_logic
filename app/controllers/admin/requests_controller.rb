class Admin::RequestsController < ApplicationController
  before_action :admin_user

  def show
    @request = Request.find(params[:id])
  end

  def index
    @requests = Request.includes(:user, :category).order(created_at: :desc)
    if params[:status].present?
      @requests = @requests.where(status: params[:status])
    end

    approved_requests = Request.joins(:category).where(status: ["approved", "承認", "承認済み"])

    monthly_data = approved_requests.to_a
                      .group_by { |r| r.applied_at&.strftime('%Y/%m') }
                      .transform_values { |reqs| reqs.sum(&:total_amount_incl_tax) }
                      .compact
                      .sort.to_h

    @monthly_labels = monthly_data.keys
    @monthly_values = monthly_data.values

    category_data = approved_requests.group("categories.account_item").sum(:total_amount_incl_tax)
    @category_labels = category_data.keys
    @category_values = category_data.values
    
    respond_to do |format|
      format.html do
        @requests = @requests.page(params[:page])
      end
      format.csv do
        send_data generate_csv(@requests), filename: "requests-#{Date.today}.csv", type: "text/csv; charset=utf-8"
      end
    end
  end

  def update
    @request = Request.find(params[:id])

    if request_params[:status] == "承認済み"
      if @request.update(status: "承認済み")
        if @request.category&.account_item == "貯蔵品（在庫連動）"
          inventory = Inventory.create!(
            request_id: @request.id,
            location: @request.user.location,
            vendor: @request.vendor,
            unit_price_excl_tax: @request.unit_price_excl_tax,
            stock_quantity: 1,
            purchase_date: Date.today,
            status: "在庫あり",
          )

          InventoryHistory.create!(
            inventory_id: inventory.id,
            user_id: Current.user.id,
            quantity: 1,
            status: :fix,
          )
          @notice_message = "申請を承認し、貯蔵品棚卸表に反映しました。"
        elsif @request.unit_price_excl_tax >= 100000
          Asset.create!(
            request_id: @request.id,
            location: @request.user.location,
            acquisition_cost_excl: @request.unit_price_excl_tax,
            useful_life_years: 4,
            depreciation_method: "定額法",
            service_start_date: Date.today,
            vendor: @request.vendor,
            purchase_date: Date.today,
            status: "稼働中",
          )
          @notice_message = "申請を承認し、10万円以上のマスタとして固定資産台帳に自動登録しました。"
        else
          @notice_message = "申請を承認しました。"
        end

        redirect_to admin_requests_path, notice: @notice_message
      else
        render :show
      end
    else
      @request.update(status: "差戻し")

      redirect_to admin_requests_path, notice: "申請を差戻ししました。"
    end
  end

  private

  def admin_user
    if !Current.user&.admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end

  def request_params
    params.require(:request).permit(:status)
  end

  def generate_csv(requests)
    require 'csv'

    bom = "\uFEFF"
    
    csv_data = CSV.generate(bom) do |csv|
      csv << ["ID", "申請者", "申請日", "勘定科目", "カテゴリ名", "購入先", "税抜単価", "税込合計金額", "ステータス"]

      requests.each do |req|
        csv << [
          req.id,
          req.user&.name,
          req.applied_at,
          req.category&.account_item,
          req.category&.name,
          req.vendor,
          req.unit_price_excl_tax,
          req.total_amount_incl_tax,
          req.status
        ]
      end
    end
    csv_data
  end

end
