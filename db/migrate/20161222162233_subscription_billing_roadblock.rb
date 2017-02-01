class SubscriptionBillingRoadblock < ActiveRecord::Migration
  def change
  	add_column :businesses, :subscription_billing_roadblock, :boolean, default: false
  end
end
