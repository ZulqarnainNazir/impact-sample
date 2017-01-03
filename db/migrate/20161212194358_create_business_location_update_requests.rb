class CreateBusinessLocationUpdateRequests < ActiveRecord::Migration
  def change
    create_table :business_location_update_requests do |t|
      t.references :business_update_request_id, index: { name: 'business_location_business_update_idx' }
      t.string :name, null: false
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.string :email
      t.text :service_area
      t.boolean :external_service_area, default: false, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps null: false
    end
  end
end
