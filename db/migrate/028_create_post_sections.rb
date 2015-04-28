class CreatePostSections < ActiveRecord::Migration
  def change
    create_table :post_sections do |t|
      t.references :post, index: true, foreign_key: true
      t.text :heading, null: false
      t.text :content
      t.text :ancestry
      t.integer :kind, defualt: 0, null: false
      t.integer :position
      t.timestamps null: false
    end
  end
end
