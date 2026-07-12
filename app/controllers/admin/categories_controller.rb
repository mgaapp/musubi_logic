class Admin::CategoriesController < ApplicationController
   def index
    @categories = Category.all 
   end
   
   def new
      @category=Category.new
    end

    def create
      @category=Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "勘定科目を追加しました"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def category_params
        params.require(:category).permit(:name, :account_item)
    end
  end