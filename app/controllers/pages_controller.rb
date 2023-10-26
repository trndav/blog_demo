class PagesController < ApplicationController 
  def home
    #check if user is not logged, if not logged then return early
    return unless current_user
    # check if user has payment processor
    return if current_user.payment_processor.nil?
      @portal_session = current_user.payment_processor.billing_portal        
  end
  def about
  end
end
