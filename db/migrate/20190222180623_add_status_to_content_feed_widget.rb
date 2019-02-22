class AddStatusToContentFeedWidget < ActiveRecord::Migration
  def change
    add_column :content_feed_widgets, :status, :bool
  end
end
