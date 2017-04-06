class AddBusinessIdToAhoyMessages < ActiveRecord::Migration
  def change
  	add_column :ahoy_messages, :business_id, :integer
  end
end
