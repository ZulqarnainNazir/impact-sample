class CreateContentCategories < ActiveRecord::Migration
  def change
    create_table :content_categories do |t|
      t.references :business, index: true, null: false
      t.text :name, null: false
      t.timestamps null: false
    end
  end
end
