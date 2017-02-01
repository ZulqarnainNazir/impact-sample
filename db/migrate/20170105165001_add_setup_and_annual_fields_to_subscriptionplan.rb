class AddSetupAndAnnualFieldsToSubscriptionplan < ActiveRecord::Migration
  def change
    add_column :subscription_plans, :setup_name, :text, default: "N/A"
    add_column :subscription_plans, :amount_annual, :decimal, default: 0.00, precision: 10, scale: 2
  end
end
