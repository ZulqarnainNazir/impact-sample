class ChangeSubscriptionPlanDefaultTo0 < ActiveRecord::Migration
  def change
  	change_column_default(:subscription_plans, :trial_period, 0)
  end
end
