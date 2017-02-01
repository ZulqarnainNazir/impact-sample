class AddDescriptionToSubscriptionPlans < ActiveRecord::Migration
  def change
  	add_column :subscription_plans, :description, :text
  end
end
