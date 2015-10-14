class AddMarketingRemindsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :app_marketing_reminders, :boolean, default: true, null: false
    add_column :users, :email_marketing_reminders, :boolean, default: true, null: false
  end
end
