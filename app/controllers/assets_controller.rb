class AssetsController < ApplicationController
    def index
     @assets = Asset.includes(request: :category).all
    end
end
