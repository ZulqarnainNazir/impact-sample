class AddIndexesToContentClassifications < ActiveRecord::Migration
  def change
    add_index :content_categorizations, %i[content_item_type content_item_id], name: 'index_content_categorizations_on_polymorphic_content_item'
    add_index :content_taggings, %i[content_item_type content_item_id]
  end
end
