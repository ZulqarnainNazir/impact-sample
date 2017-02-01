class AddBillOnlineToBusiness < ActiveRecord::Migration
  def change
  	add_column :businesses, :bill_online, :boolean, default: true
  end
end
