class AddNameToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :name, :string
    remove_column :orders, :first_name
    remove_column :orders, :last_name
  end

  def down
    remove_column :orders, :name
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
  end
end
