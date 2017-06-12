class CreateContentFeedWidgetContentTags < ActiveRecord::Migration
  def change
    create_table :content_feed_widget_content_tags do |t|
      t.references :content_feed_widget, index: {:name => "content_fwidget_tags_on_fwidget_idx"}
      t.references :content_tag, index: {:name => "content_fwidget_on_tags_idx"}

      t.timestamps null: false
    end
  end
end
