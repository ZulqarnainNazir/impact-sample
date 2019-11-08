class AddSettingsToContentFeedWidgets < ActiveRecord::Migration
  def change
    add_column :content_feed_widgets, :items_limit,       :integer
    add_column :content_feed_widgets, :link_id,           :integer
    add_column :content_feed_widgets, :link_external_url, :string
    add_column :content_feed_widgets, :link_target_blank, :boolean
    add_column :content_feed_widgets, :link_no_follow,    :boolean
    add_column :content_feed_widgets, :link_version,      :integer
  end
end
