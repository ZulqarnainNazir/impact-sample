class AddSpoofToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :spoof, :string
  end
end
