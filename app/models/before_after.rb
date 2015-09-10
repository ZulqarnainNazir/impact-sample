class BeforeAfter < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings

  has_placed_image :before_image
  has_placed_image :after_image
  has_placed_image :main_image

  validates :business, presence: true
  validates :title, presence: true

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def sorting_date
    created_at
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
