class CreateEventDefinitions < ActiveRecord::Migration
  def change
    create_table :event_definitions do |t|
      t.references :business, index: true, null: false
      t.text :title, null: false
      t.text :subtitle
      t.text :description
      t.text :price
      t.text :url
      t.text :phone
      t.text :repetition
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.timestamps null: false
    end
  end
end
