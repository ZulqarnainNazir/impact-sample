class AddKindToPlacements < ActiveRecord::Migration
  def change
    add_column :placements, :kind, :integer, default: 0, null: false
  end
end
