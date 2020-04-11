class AddStatusToProducts < ActiveRecord::Migration
  def change
    add_column :products, :status, :integer, null: false, default: 0
  end
end
