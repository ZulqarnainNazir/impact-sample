class ChangeDefaultAffiliatePercentage < ActiveRecord::Migration
  def change
  	change_column :subscription_affiliates, :rate, :decimal, :precision => 6, :scale => 4, :default => 0.20
  end
end