class ApplicationController < ActionController::Base
    before_action :set_notifications, if: :current_user
    before_action :set_query

    def set_query
        @query = Post.ransack(params[:q])
    end

    private
    def set_notifications
        # .newest_first is same like .where().order(created_at: :desc)
        notifications = Notification.where(recipient: current_user).newest_first.limit(9)
        @unread = Notification.unread
        @read = Notification.read
    end
end
