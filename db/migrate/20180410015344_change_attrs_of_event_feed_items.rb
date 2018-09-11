class ChangeAttrsOfEventFeedItems < ActiveRecord::Migration
  def change
    remove_index :event_feed_items, :location_id
    remove_index :event_feed_items, :event_feed_id
    drop_table :event_feed_items

    add_column :event_definitions, :event_feed_id, :integer
    add_index :event_definitions, :event_feed_id

    add_column :event_definitions, :import_pending, :boolean, default: false
  end
end
