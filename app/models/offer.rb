class Offer < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern
  include ContentSlugConcern
  attr_accessor :minimal_validations

  enum kind: {
    image_left: 0,
    image_right: 1,
  }

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings

  has_placed_image :offer_image
  has_placed_image :main_image

  has_attached_file :coupon

  validates_attachment_content_type :coupon, content_type: /\A(image\/.*|application\/pdf)\Z/
  validates_attachment_size :coupon, in: 0..10.megabytes

  validates :business, presence: true
  validates :published_on, presence: true

  with_options unless: :minimal_validations do
    validates :description, presence: true
    validates :terms, presence: true
    validates :offer, presence: true
    validates :title, presence: true
    validates :offer_image_placement, presence: true
  end

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

  def valid_until=(*args)
    super DatepickerParser.parse(*args)
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def published_at
    published_on || updated_at
  end


  def default_published_on
    self.published_on ||= self.created_at
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
