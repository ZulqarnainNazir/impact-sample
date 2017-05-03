class AddUserIdToMissionNotificationSettings < ActiveRecord::Migration
  def change
    add_column :mission_notification_settings, :user_id, :integer, index: true
    add_column :mission_notification_settings, :daily_due_notification_preference, :integer, default: 0
    add_column :mission_notification_settings, :weekly_due_notification_preference, :integer, default: 0
  end
end
