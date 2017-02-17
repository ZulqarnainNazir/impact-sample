class AddAffiliateBoolean < ActiveRecord::Migration
  def change
  	add_column :businesses, :affiliate_activated, :boolean
  end
end
