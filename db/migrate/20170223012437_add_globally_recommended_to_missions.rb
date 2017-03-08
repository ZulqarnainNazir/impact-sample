class AddGloballyRecommendedToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :globally_recommended, :boolean, default: false
  end
end
