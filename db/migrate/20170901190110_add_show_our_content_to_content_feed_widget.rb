class AddShowOurContentToContentFeedWidget < ActiveRecord::Migration
  def change
  	add_column :content_feed_widgets, :show_our_content, :boolean, default: true
  end
end
