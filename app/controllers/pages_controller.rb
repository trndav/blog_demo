class PagesController < ApplicationController
 
  def home
    if current_user
      @portal_session = current_user.payment_processor.billing_portal    
    end
  end

  def about
  end
end
