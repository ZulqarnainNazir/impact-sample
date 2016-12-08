class AddPublishedStatusToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :published_status, :boolean
  end
end
