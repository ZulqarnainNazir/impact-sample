class Gallery < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern
  include ContentSlugConcern

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings
  has_many :gallery_images, dependent: :destroy

  has_placed_image :main_image

  accepts_nested_attributes_for :gallery_images, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['title'].blank? &&
      a['description'].blank? &&
      a['gallery_image_placement_attributes'].kind_of?(Hash) &&
      a['gallery_image_placement_attributes'].select { |k,_| !%w[kind image_business image_user].include?(k) }.values.all?(&:blank?)
    )
  }

  validates :business, presence: true
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
      slug: title.gsub(/['’]/, '').parameterize,
    }
  end
end
