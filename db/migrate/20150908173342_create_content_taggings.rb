class CreateContentTaggings < ActiveRecord::Migration
  def change
    create_table :content_taggings do |t|
      t.references :content_item, polymorphic: true, null: false
      t.references :content_tag, index: true, null: false
      t.timestamps null: false
    end
  end
end
