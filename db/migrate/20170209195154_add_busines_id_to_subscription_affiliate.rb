class AddBusinesIdToSubscriptionAffiliate < ActiveRecord::Migration
  def change
  	add_column :subscription_affiliates, :business_id, :integer
  end
end
