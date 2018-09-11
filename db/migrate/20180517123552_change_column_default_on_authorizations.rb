class ChangeColumnDefaultOnAuthorizations < ActiveRecord::Migration
  def change
    change_column_default :authorizations, :event_import_notifications, true
    change_column_null :authorizations, :event_import_notifications, false
  end
end
