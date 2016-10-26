class CreateToDoNotificationSettings < ActiveRecord::Migration
  def change
    create_table :to_do_notification_settings do |t|
      t.boolean :assigned, default: true
      t.boolean :updates_or_comments, default: true
      t.boolean :deadline_approaching, default: true
      t.boolean :due, default: true
      t.boolean :accepted, default: true
      t.integer :overdue_reminder_interval, default: 0
      t.integer :business_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :to_do_notification_settings, :business_id
    add_index :to_do_notification_settings, :user_id
  end
end
