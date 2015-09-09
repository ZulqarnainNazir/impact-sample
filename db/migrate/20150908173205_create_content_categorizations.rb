class CreateContentCategorizations < ActiveRecord::Migration
  def change
    create_table :content_categorizations do |t|
      t.references :content_category, index: true, null: false
      t.references :content_item, polymorphic: true, null: false
      t.timestamps null: false
    end
  end
end
