class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.references :business, index: true, null: false
      t.text :title, null: false
      t.text :description
      t.timestamps null: false
    end
  end
end
