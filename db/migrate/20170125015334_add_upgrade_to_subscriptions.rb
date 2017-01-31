class AddUpgradeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :upgrade_to, :integer
  end
end
