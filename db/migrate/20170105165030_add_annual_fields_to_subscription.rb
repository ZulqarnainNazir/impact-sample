class AddAnnualFieldsToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :annual, :boolean, default: false
  end
end
