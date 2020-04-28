class AddMercantileEnabledToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :mercantile_enabled, :boolean, null: false, default: false
  end
end
