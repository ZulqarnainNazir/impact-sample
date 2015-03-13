class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.references :location, index: true, null: false
      t.time :opens_at
      t.time :closes_at
      t.boolean :sunday, default: false, null: false
      t.boolean :monday, default: false, null: false
      t.boolean :tuesday, default: false, null: false
      t.boolean :wednesday, default: false, null: false
      t.boolean :thursday, default: false, null: false
      t.boolean :friday, default: false, null: false
      t.boolean :saturday, default: false, null: false
      t.timestamps null: false
    end
  end
end
