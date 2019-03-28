class AddRecommendedToCommunityBusiness < ActiveRecord::Migration
  def change
    add_column :community_businesses, :recommended, :boolean
  end
end
