class Offer < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  enum kind: {
    image_left: 0,
    image_right: 1,
  }

  belongs_to :business

  has_placed_image :offer_image

  has_attached_file :coupon

  validates_attachment_content_type :coupon, content_type: /\A(image\/.*|application\/pdf)\Z/
  validates_attachment_size :coupon, in: 0..10.megabytes

  validates :business, presence: true
  validates :description, presence: true
  validates :terms, presence: true
  validates :offer, presence: true
  validates :title, presence: true
  validates :offer_image_placement, presence: true

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end

  def offer_html
    Sanitize.fragment(offer.to_s, Sanitize::Config::RELAXED).html_safe
  end

  def terms_html
    Sanitize.fragment(terms.to_s, Sanitize::Config::RELAXED).html_safe
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
