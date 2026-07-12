class Admin::InventoryHistoriesController < ApplicationController
  before_action :admin_user

  def index
    @inventory_histories = InventoryHistory.includes(:user, inventory: { request: :category })
                                           .order(created_at: :desc)
                                           .page(params[:page])
  end
end

