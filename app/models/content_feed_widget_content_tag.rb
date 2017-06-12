class ContentFeedWidgetContentTag < ActiveRecord::Base
  belongs_to :content_feed_widget
  belongs_to :content_tag
end
