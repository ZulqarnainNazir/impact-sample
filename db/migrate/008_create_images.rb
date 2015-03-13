class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :business, index: true, null: false
      t.references :user, index: true, null: false
      t.string :alt
      t.string :title
      t.string :attachment_cache_url
      t.string :attachment_content_type
      t.string :attachment_file_name
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.timestamps null: false
    end
  end
end
