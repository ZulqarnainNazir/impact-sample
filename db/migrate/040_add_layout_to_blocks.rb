class AddLayoutToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :layout, :string, :default => "default"
  end
end
