class AddDowngradeToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :downgrade_to, :integer
  end
end
