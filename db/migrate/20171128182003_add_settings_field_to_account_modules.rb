class AddSettingsFieldToAccountModules < ActiveRecord::Migration
  def change
  	add_column :account_modules, :settings, :json
  end
end
