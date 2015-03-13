class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name, null: false
      t.string :facebook_id
      t.string :google_plus_id
      t.string :linkedin_id
      t.string :twitter_id
      t.string :youtube_id
      t.text :description
      t.timestamps null: false
    end
  end
end
