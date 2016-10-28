class QuickPost < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern
  include ContentSlugConcern

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings

  has_placed_image :quick_post_image

  validates :content, presence: true
  validates :published_on, presence: true
  validates :title, presence: true

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 }
  end

  def published_on=(value)
    if value.to_s.split('/').length == 3
      values = value.split('/')
      values = values[-1..-1] + values[0..-2]
      super(Date.parse(values.join('/')))
    else
      super
    end
  end

  def default_published_on
    self.published_on ||= self.created_at
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def published_at
    published_on || updated_at
  end

  def sorting_date
    published_at
  end

  def to_generic_param
    {
      year: published_at.strftime('%Y'),
      month: published_at.strftime('%m'),
      day: published_at.strftime('%d'),
      id: id,
      slug: slug,
    }
  end
end
