class Admin::InventoryHistoriesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @inventory_histories = InventoryHistory.order("created_at DESC")
end
