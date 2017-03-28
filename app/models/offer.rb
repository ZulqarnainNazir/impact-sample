class Offer < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern
  include ContentSlugConcern
  include WebsiteHelper
  include Rails.application.routes.url_helpers
  include ExternalUrlHelper
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
  has_many :shares, as: :shareable, dependent: :destroy

  has_placed_image :offer_image
  has_placed_image :main_image

  has_attached_file :coupon

  validates_attachment_content_type :coupon, content_type: /\A(image\/.*|application\/pdf)\Z/
  validates_attachment_size :coupon, in: 0..10.megabytes


  validates_presence_of :business
  validates_presence_of :published_on, if: :not_draft?
  validates_presence_of :terms, if: :not_draft?
  validates_presence_of :offer, if: :not_draft?
  validates_presence_of :title

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 }
  end

  def share_image_url
    offer_image.try(:attachment_full_url, :original)
  end

  def share_callback_url
    url_for("http://#{website_host(self.business.website)}/#{path_to_external_content(self)}")
  end

  # This is not a duplicate of share_image_url
  # This method works with spaces in image names for og:images
  # share_image_url strips the url special chars when this leaves them.
  def og_image_url
    offer_image.try(:attachment_full_url, :jumbo)
  end

  def image_size
    FastImage.size(self.og_image_url)
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

  def not_draft?
    self.published_status
  end

  def valid_until=(*args)
    super DatepickerParser.parse(*args)
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def sorting_date
    #change made to published_at, see comments there as of 2.16.17
    published_at
  end

  def published_at
    #method was originaly designed to provide published_on dates, and in lieu of that,
    #updated_at. This is used primarily for searches and ordering via ElasticSearch,
    #but may also be used elsewhere. The method was changed on 2.16.17 to use created_at
    #if published_on is nil. published_on is usually nil with older posts. This is because
    #published_on was implemented in October 2016, when there were already posts present.
    #using created_at is a workaround for old posts that don't have a published_on value.
    published_on || created_at
  end


  def default_published_on
    self.published_on ||= self.created_at
  end

  def to_generic_param
    {
      year: published_at.strftime('%Y'),
      month: published_at.strftime('%m'),
      day: published_at.strftime('%d'),
      id: id,
      slug: slug
    }
  end

  def to_generic_param_two
    [
      published_at.strftime('%Y').to_s,
      published_at.strftime('%m').to_s,
      published_at.strftime('%d').to_s,
      "#{id}",
      slug.to_s
    ]
  end
end
