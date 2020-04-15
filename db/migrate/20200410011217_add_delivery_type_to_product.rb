class AddDeliveryTypeToProduct < ActiveRecord::Migration
  def up
    add_column :products, :delivery_type, :integer, null: false, default: 0
    remove_column :products, :require_shipping_address
  end

  def down
    remove_column :products, :delivery_type
    add_column :products, :require_shipping_address, :boolean, null: false, default: true
  end
end
