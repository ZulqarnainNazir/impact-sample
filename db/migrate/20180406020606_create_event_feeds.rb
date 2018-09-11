class CreateEventFeeds < ActiveRecord::Migration
  def change
    create_table :event_feeds do |t|
      t.integer :business_id, index: true
      t.integer :creator_id, index: true
      t.string :name
      t.string :url

      t.timestamps null: false
    end
  end
end
