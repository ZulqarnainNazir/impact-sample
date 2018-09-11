class AddEventImportNotificationsToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :event_import_notifications, :boolean, default: false
  end
end
