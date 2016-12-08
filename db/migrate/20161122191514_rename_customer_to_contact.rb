class RenameCustomerToContact < ActiveRecord::Migration
  def change
    rename_table :customers, :contacts
  end
end
