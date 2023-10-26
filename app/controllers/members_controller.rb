class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_subscription_status

  def dashboard
  end

  def check_subscription_status
    unless current_user.active_subscription
      redirect_to checkout_path(
        line_items: ["price_1O5QHLEQZj9AchNLjUsGDy5C"],
        payment_mode: "subscription"),
        alert: "You must have active subscription to view this page."
    end
  end
end
