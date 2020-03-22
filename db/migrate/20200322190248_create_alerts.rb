class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :alert_type, default: 0, null: false
      t.text :message
      t.integer :business_id

      t.timestamps null: false
    end
  end
end
