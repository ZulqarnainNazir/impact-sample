class AddToContentFeedWidgetCompanyListIdsArray < ActiveRecord::Migration
  def change
  	add_column :content_feed_widgets, :company_list_ids, :text, array:true, default: []
  end
end
