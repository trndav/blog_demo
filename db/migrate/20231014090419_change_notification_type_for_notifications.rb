class ChangeNotificationTypeForNotifications < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :notification_type, :type
  end
end
