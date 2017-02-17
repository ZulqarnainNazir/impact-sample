class ModifyAffiliateActivated < ActiveRecord::Migration
  def change
  	change_column :businesses, :affiliate_activated, :boolean, default: false
  end
end
