class SearchController < ApplicationController
  def index
    if params[:q].present?
      @query = Post.ransack(params[:q])
      @posts = @query.result(distinct: true)
    else
      # Handle the case when no search parameters are provided.
      @posts = Post.includes(:user, :rich_text_body).all
    end
  end
end
