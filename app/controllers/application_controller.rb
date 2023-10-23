class ApplicationController < ActionController::Base
    before_action :set_notifications, if: :current_user
    before_action :set_categories 
    before_action :set_query

    def set_query
        @query = Post.ransack(params[:q])
    end

    def set_categories
        @nav_categories = Category.where(display_in_nav: true)
    end

    def is_admin!
         redirect_to root_path, alert: "You are not authorized to do that." unless current_user&.admin?
    end

    private
    def set_notifications
        # .newest_first is same like .where().order(created_at: :desc)
        # .includes(:recipient) is ActiveRecord method used to optimize database queries
        notifications = Notification.where(recipient: current_user).newest_first.limit(9)
        @unread = Notification.includes([:recipient]).unread
        @read = Notification.includes([:recipient]).read
    end
end
