class AddSocialProfilesToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :foursquare_id, :text
    add_column :businesses, :zillow_id, :text
    add_column :businesses, :opentable_id, :text
    add_column :businesses, :trulia_id, :text
    add_column :businesses, :realtor_id, :text
    add_column :businesses, :tripadvisor_id, :text
    add_column :businesses, :houzz_id, :text
  end
end
