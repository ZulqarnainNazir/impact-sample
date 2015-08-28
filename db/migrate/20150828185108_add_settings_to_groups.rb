class AddSettingsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :settings, :json
  end
end
