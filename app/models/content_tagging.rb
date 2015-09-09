class ContentTagging < ActiveRecord::Base
  belongs_to :content_tag
  belongs_to :content_item, polymorphic: true
end
