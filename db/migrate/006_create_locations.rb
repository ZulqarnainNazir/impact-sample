class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :business, index: true, null: false
      t.string :name, null: false
      t.string :email
      t.string :phone_number, null: false
      t.string :street1, null: false
      t.string :street2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.boolean :hide_address, default: false, null: false
      t.boolean :hide_phone, default: false, null: false
      t.timestamps null: false
    end
  end
end
