class AddBusinessIdToToDoLists < ActiveRecord::Migration
  def change
    add_column :to_do_lists, :business_id, :integer
    add_index :to_do_lists, :business_id
  end
end
