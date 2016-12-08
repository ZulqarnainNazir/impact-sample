class AddGroupToToDos < ActiveRecord::Migration
  def change
    add_column :to_dos, :group, :integer, default: 0
  end
end
