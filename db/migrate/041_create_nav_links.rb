class CreateNavLinks < ActiveRecord::Migration
  def change
    create_table :nav_links do |t|
      t.references :website, index: true, null: false
      t.references :webpage, index: true
      t.text :ancestry
      t.text :label
      t.text :url
      t.integer :location, default: 0, null: false
      t.integer :kind, default: 0, null: false
      t.integer :position
      t.timestamps null: false
    end
  end
end
