class SplitNameOnContacts < ActiveRecord::Migration
  def up
    rename_column :contacts, :name, :first_name
    add_column :contacts, :last_name, :string
  end
  def down
    rename_column :contacts, :first_name, :name
    remove_column :contacts, :last_name
  end
end
