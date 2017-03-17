class AddFacebookIdToShares < ActiveRecord::Migration
  def change
  	add_column :shares, :facebook_id, :text
  end
end
