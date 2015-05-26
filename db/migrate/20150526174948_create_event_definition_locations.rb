class CreateEventDefinitionLocations < ActiveRecord::Migration
  def change
    create_table :event_definition_locations do |t|
      t.references :event_definition, index: true, null: false
      t.references :location, index: true, null: false
      t.timestamps null: false
    end
  end
end
