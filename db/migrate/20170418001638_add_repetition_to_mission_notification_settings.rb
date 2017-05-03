class AddRepetitionToMissionNotificationSettings < ActiveRecord::Migration
  def change
    add_column :mission_notification_settings, :summary_frequency, :text
    add_column :mission_notification_settings, :suggestions_frequency, :text
  end
end
