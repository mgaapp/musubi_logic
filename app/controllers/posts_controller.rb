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

 private

 def post_params
   params.require(:post).permit(:title, :content)
 end
end