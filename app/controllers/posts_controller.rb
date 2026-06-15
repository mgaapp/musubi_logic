class PostsController < ApplicationController
  def index
    @posts = Post.all 
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

 def post_params
   params.require(:post).permit(:title, :content, :answer)
 end
end