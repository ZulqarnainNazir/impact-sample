class AddToDosEnabledToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :to_dos_enabled, :boolean
  end
end
