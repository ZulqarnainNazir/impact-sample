class RemoveNotNullConstratFromEmailOnContacts < ActiveRecord::Migration
  def change
    change_column :contacts, :email, :string, :null => true
  end
end
