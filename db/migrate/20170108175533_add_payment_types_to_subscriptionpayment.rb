class AddPaymentTypesToSubscriptionpayment < ActiveRecord::Migration
  def change
  	remove_column :subscription_payments, :setup, :boolean
  	add_column :subscription_payments, :monthly, :boolean, default: false
  	add_column :subscription_payments, :annual, :boolean, default: false
  	add_column :subscription_payments, :setup, :boolean, default: false
  end
end
