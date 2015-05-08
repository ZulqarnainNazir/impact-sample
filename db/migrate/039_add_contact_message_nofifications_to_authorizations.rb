class AddContactMessageNofificationsToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :contact_message_notifications, :boolean, default: true, null: false
  end
end
