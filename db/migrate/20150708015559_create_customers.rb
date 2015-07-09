class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :business, index: true, null: false
      t.text :name, null: false
      t.text :email, null: false
      t.text :phone
      t.text :notes
      t.timestamps null: false
    end
  end
end
