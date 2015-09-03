class AddBusinessDetailsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :business_client, :boolean, default: false, null: false
    add_column :customers, :business_name, :text
    add_column :customers, :business_url, :text
  end
end
