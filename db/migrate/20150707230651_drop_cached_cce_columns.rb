class DropCachedCceColumns < ActiveRecord::Migration
  def change
    remove_column :businesses, :cce_name, :text
    remove_column :users, :cce_url, :text
  end
end
