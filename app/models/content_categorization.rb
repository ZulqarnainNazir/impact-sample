class ContentCategorization < ActiveRecord::Base
  belongs_to :content_category
  belongs_to :content_item, polymorphic: true
end
