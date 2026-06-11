class Admin::InventoryHistoriesController < ApplicationController
  before_action :admin_user

  def index
    @inventory_histories = InventoryHistory.order("created_at DESC")
  end
end

