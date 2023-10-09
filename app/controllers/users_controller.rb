class UsersController < ApplicationController
  before_action :set_user
  def profile
    if @user.views.nil?
      @user.views = 0
      @user.update(views: @user.views + 1)
    else
      @user.update(views: @user.views + 1)
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
