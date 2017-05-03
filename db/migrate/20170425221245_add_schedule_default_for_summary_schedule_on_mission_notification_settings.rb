class AddScheduleDefaultForSummaryScheduleOnMissionNotificationSettings < ActiveRecord::Migration
  def change
    change_column_default :mission_notification_settings, :suggestions_frequency, '{"interval":1,"until":null,"count":null,"validations":{"day":[1]},"rule_type":"IceCube::WeeklyRule"}'
  end
end
