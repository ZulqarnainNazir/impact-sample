class AddActivatedBooleanToSubscriptionPlan < ActiveRecord::Migration
  def change
  	add_column :subscription_plans, :activated, :boolean
  end
end
