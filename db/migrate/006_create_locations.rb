class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :business, index: true, null: false
      t.string :name, null: false
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.string :email
      t.text :service_area
      t.boolean :hide_address, default: false, null: false
      t.boolean :hide_phone, default: false, null: false
      t.boolean :hide_email, default: false, null: false
      t.boolean :external_service_area, default: false, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.timestamps null: false
    end
  end
end
