class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name, null: false
      t.string :tagline
      t.string :website_url
      t.string :facebook_id
      t.string :google_plus_id
      t.string :linkedin_id
      t.string :twitter_id
      t.string :youtube_id
      t.text :description
      t.integer :kind, default: 0, null: false
      t.integer :year_founded
      t.timestamps null: false
    end
  end
end
