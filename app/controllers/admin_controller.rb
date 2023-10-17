class AdminController < ApplicationController
  def index
  end
  def posts
    # When posts get pulled, it will get users and comments also, DB N+1 problem.
    # @posts = Post.all.includes(:user, :comments)
    @posts = Post.all.includes(:user)
  end
  def comments
  end
  def users
  end
  def show_post
    @post = Post.includes(:user, :comments).find(params[:id])
  end
end
