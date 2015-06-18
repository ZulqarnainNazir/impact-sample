class AddCceColumns < ActiveRecord::Migration
  def change
    add_column :businesses, :cce_id, :integer
    add_column :users, :cce_id, :integer
    add_column :users, :cce_url, :text
  end
end
