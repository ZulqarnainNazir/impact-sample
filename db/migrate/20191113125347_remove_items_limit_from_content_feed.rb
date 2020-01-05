class RemoveItemsLimitFromContentFeed < ActiveRecord::Migration
  def change
    remove_column :content_feed_widgets, :items_limit, :integer
  end
end
