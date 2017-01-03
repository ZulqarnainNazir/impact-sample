class AddBusinessFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :name, :string
    add_column :companies, :tagline, :string
    add_column :companies, :website_url, :string
    add_column :companies, :facebook_id, :string
    add_column :companies, :google_plus_id, :string
    add_column :companies, :linkedin_id, :string
    add_column :companies, :twitter_id, :string
    add_column :companies, :youtube_id, :string
    add_column :companies, :description, :text
    add_column :companies, :citysearch_id, :string
    add_column :companies, :instagram_id, :string
    add_column :companies, :pinterest_id, :string
    add_column :companies, :yelp_id, :string
    add_column :companies, :foursquare_id, :string
    add_column :companies, :zillow_id, :string
    add_column :companies, :opentable_id, :string
    add_column :companies, :trulia_id, :string
    add_column :companies, :realtor_id, :string
    add_column :companies, :tripadvisor_id, :string
    add_column :companies, :houzz_id, :string
  end
end
