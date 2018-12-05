class AddCommunityToBusiness < ActiveRecord::Migration
  def change
    add_reference :businesses, :community, index: true, foreign_key: true
  end
end
