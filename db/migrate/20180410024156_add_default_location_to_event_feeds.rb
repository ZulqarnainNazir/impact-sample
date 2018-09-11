class AddDefaultLocationToEventFeeds < ActiveRecord::Migration
  def change
    add_column :event_feeds, :location_id, :integer, index: true
  end
end
