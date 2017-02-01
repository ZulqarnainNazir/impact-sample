class DefaultSubscriptionStateChange < ActiveRecord::Migration
  def change
  	change_column_default(:subscriptions, :state, "inactive")
  end
end
