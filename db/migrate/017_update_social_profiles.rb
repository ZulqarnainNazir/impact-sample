class UpdateSocialProfiles < ActiveRecord::Migration
  def change
    add_column :businesses, :citysearch_id, :string
    add_column :businesses, :instagram_id, :string
    add_column :businesses, :pinterest_id, :string
    add_column :businesses, :yelp_id, :string
  end
end
