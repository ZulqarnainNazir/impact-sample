class AddTimeZoneToEventFeeds < ActiveRecord::Migration
  def change
    add_column :event_feeds, :time_zone, :string
  end
end
