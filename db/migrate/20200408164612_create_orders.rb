class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :shipping_address
      t.decimal :total_amount, precision: 8, scale: 2
      t.string :stripe_checkout_session_id
      t.string :stripe_customer_id
      t.integer :business_id

      t.timestamps null: false
    end
  end
end
