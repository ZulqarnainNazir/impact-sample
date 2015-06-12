class AddKindToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :kind, :integer, default: 0, null: false
  end
end
