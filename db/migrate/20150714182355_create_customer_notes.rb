class CreateCustomerNotes < ActiveRecord::Migration
  def change
    create_table :customer_notes do |t|
      t.references :customer, index: true, null: false
      t.text :content, null: false
      t.text :user_name, null: false
      t.timestamps null: false
    end
  end
end
