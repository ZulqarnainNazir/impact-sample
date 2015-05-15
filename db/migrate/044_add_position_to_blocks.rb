class AddPositionToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :position, :integer, default: 0, null: false
  end
end
