class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :business, index: true, null: false
      t.references :event_definition, index: true, null: false
      t.date :occurs_on
      t.timestamps null: false
    end
  end
end
