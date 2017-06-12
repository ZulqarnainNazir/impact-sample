class CreateContentFeedWidgetContentCategories < ActiveRecord::Migration
  def change
    create_table :content_feed_widget_content_categories do |t|
      t.references :content_feed_widget, index: {:name => "content_fwidget_cats_on_fwidget_idx"}
      t.references :content_category, index: {:name => "content_fwidget_on_cats_idx"}

      t.timestamps null: false
    end
  end
end
