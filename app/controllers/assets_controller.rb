class AssetsController < ApplicationController
  # 資産一覧画面の表示
  def index
    @assets = Asset.includes(request: :category).all
  end
end
