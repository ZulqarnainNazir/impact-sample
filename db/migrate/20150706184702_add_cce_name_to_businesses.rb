class AddCceNameToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :cce_name, :text
  end
end
