class SplitNameOnContactMessages < ActiveRecord::Migration
  def up
    rename_column :contact_messages, :customer_name, :customer_first_name
    add_column :contact_messages, :customer_last_name, :string
  end
  def down
    rename_column :contact_messages, :customer_first_name, :customer_name
    remove_column :contact_messages, :customer_last_name
  end
end
