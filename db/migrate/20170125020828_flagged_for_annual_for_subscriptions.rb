class FlaggedForAnnualForSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :flagged_for_annual, :boolean, :default => false
  end
end
