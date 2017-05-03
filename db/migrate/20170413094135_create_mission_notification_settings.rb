class CreateMissionNotificationSettings < ActiveRecord::Migration
  def change
    create_table :mission_notification_settings do |t|
      t.integer :business_id, index: true
      t.boolean :weeky_due_notification, default: true
      t.boolean :daily_due_notification, default: true
      t.boolean :summary_notification, default: true
      t.boolean :suggestions_notification, default: true
      t.boolean :comment_notification, default: true

      t.timestamps null: false
    end
  end
end
