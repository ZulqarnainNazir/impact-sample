class AddShippingRequirementToProducts < ActiveRecord::Migration
  def change
    add_column :products, :require_shipping_address, :boolean, null: false, default: true
  end
end
