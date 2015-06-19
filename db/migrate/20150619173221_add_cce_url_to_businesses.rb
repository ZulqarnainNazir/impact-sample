class AddCceUrlToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :cce_url, :text
  end
end
