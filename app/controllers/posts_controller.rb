class PostsController < ApplicationController
 before_action :admin_user, only: [:update]
  
  def index
    if params[:filter] == "unanswered"
      @posts = Post.where(answer: [nil, ""]).or(Post.where(is_public: false))
    elsif params[:filter] == "answered"
      @posts = Post.where.not(answer: [nil, ""]).where(is_public: true)
    else
    @posts = Post.all 
  end
end
   def new
    @post = Post.new
   end

  def create
    @post = Post.new(post_params)
    @post.user_id = Current.user.id
    if @post.save
      redirect_to posts_path, notice: "知見（Q&A）を新しく投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
 end
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, notice: "公式回答を登録・回答しました"
    else
      @posts = Post.all
      render :index, status: :unprocessable_entity
    end
  end
 private

 def admin_user
  if Current.user.nil? || !Current.user.admin?
    redirect_to root_path, alert: "管理者専用の機能です。アクセス権限がありません。"
  end
end

 def post_params
   params.require(:post).permit(:title, :content, :answer, :is_public)
 end
end