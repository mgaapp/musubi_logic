class InventoryHistoriesController < ApplicationController
  before_action :authenticated?

    def index
      @inventory_histories = InventoryHistory.includes(inventory: { request: :category })
                                           .order(created_at: :desc)
                                           .page(params[:page])
    end
end
