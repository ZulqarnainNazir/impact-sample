class CreateCreationPosts < ActiveRecord::Migration
  def change
    create_table :creation_posts do |t|
      t.integer :business_id
      t.text :title
      t.text :meta_description
      t.text :facebook_id
      t.text :slug
      t.datetime :published_time
      t.boolean :published_status, null: false, default: false
      t.datetime :published_on

      t.timestamps null: false
    end
  end
end
