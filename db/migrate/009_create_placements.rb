class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.references :placer, polymorphic: true, index: true, null: false
      t.references :image, index: true, null: false
      t.string :context, default: '', null: false
      t.string :style, default: '', null: false
      t.json :settings
      t.timestamps null: false
    end
  end
end
