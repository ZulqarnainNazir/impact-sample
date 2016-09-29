class AddPublishedTimeToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :published_time, :time
  end
end
