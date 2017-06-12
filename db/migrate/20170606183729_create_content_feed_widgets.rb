class CreateContentFeedWidgets < ActiveRecord::Migration
  def change
    create_table :content_feed_widgets do |t|
      t.string :name
      t.string :public_label
      t.string :uuid
      t.references :business, index: true
      t.integer :max_items
      t.string :link_label
      t.boolean :enable_search
      t.string :content_types, array: true

      t.timestamps null: false
    end
  end
end
