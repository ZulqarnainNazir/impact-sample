class CreateBusinessUpdateRequests < ActiveRecord::Migration
  def change
    create_table :business_update_requests do |t|
      t.integer :business_id
      t.integer :request_business_id
      t.string  :name, null: false
      t.string  :tagline
      t.string  :website_url
      t.string  :facebook_id
      t.string  :google_plus_id
      t.string  :linkedin_id
      t.string  :twitter_id
      t.string  :youtube_id
      t.text    :description
      t.integer :kind, default: 0, null: false
      t.integer :year_founded
      t.string  :citysearch_id
      t.string  :instagram_id
      t.string  :pinterest_id
      t.string  :yelp_id
      t.integer :plan, default: 0, null: false
      t.integer :cce_id
      t.text    :cce_url
      t.string  :foursquare_id
      t.string  :zillow_id
      t.string  :opentable_id
      t.string  :trulia_id
      t.string  :realtor_id
      t.string  :tripadvisor_id
      t.string  :houzz_id
      t.timestamps null: false
    end
  end
end
