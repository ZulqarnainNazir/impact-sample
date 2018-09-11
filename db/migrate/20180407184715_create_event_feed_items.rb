class CreateEventFeedItems < ActiveRecord::Migration
  def change
    create_table :event_feed_items do |t|
      t.integer :event_feed_id
      t.integer :location_id

      t.boolean :published
      t.string :title
      t.string :subtitle
      t.text :description
      t.text :repetition

      t.time :start_time
      t.date :start_date

      t.timestamps null: false
    end

    add_index :event_feed_items, :event_feed_id
    add_index :event_feed_items, :location_id
  end
end
