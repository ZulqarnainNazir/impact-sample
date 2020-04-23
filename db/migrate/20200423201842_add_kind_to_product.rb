class AddKindToProduct < ActiveRecord::Migration
  def change
    add_column :products, :product_kind, :integer, null: false, default: 0
  end
end
