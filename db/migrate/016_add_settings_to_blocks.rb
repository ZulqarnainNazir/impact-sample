class AddSettingsToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :settings, :json
  end
end
