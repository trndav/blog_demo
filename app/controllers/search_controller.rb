class SearchController < ApplicationController
  def index
    if params[:q].present?
      @query = Post.includes([:user], [:rich_text_body]).ransack(params[:q])
      @posts = @query.result(distinct: true)
      puts "Search Query: #{params[:q]}"
      puts "Generated SQL: #{@query.result.to_sql}"
    else
      # Handle the case when no search parameters are provided.
      @query = Post.ransack
      @posts = @query.result(distinct: true).includes(:user, :rich_text_body).order(created_at: :desc)
      puts "No Search Query: #{params[:q]}"
    end
  end
end
