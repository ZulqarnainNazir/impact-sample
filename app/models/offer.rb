class Offer < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

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

  with_options unless: :minimal_validations do
    validates :description, presence: true
    validates :terms, presence: true
    validates :offer, presence: true
    validates :title, presence: true
    validates :offer_image_placement, presence: true
  end

  def valid_until=(*args)
    super DatepickerParser.parse(*args)
  end

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
