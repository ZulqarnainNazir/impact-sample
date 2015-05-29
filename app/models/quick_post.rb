class QuickPost < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :business, touch: true

  has_placed_image :quick_post_image

  validates :title, presence: true
  validates :content, presence: true

  def as_indexed_json(options = {})
    as_json(methods: %i[sorting_date])
  end

  def sorting_date
    created_at
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
