class AddLastImportedToEventFeeds < ActiveRecord::Migration
  def change
    add_column :event_feeds, :last_imported, :datetime
  end
end
