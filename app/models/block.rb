class Block < ActiveRecord::Base
  include PlacedImageConcern

  store_accessor :settings, :background_color, :foreground_color, :link_color, :height, :items_limit, :well_style, :custom_class

  enum link_version: { link_none: 0, link_internal: 1, link_external: 2, }

  belongs_to :frame, polymorphic: true, touch: true
  belongs_to :link, polymorphic: true

  has_placed_image :block_background
  has_placed_image :block_image

  validates :position, presence: true
  validates :theme, presence: true
  validates :type, presence: true, exclusion: { in: %w[Block] }

  before_validation do
    self.link_no_follow = false if !link_no_follow?
    self.link_target_blank = false if !link_target_blank?
    self.link_version = :link_none unless link_internal? || link_external?
    self.position = 0 unless position?
  end

  def self.default_scope
    order(position: :asc, created_at: :asc)
  end

  def business
    if frame.is_a?(Website)
      @business ||= frame.business
    elsif frame.is_a?(Group)
      @business ||= frame.webpage.try(:website).try(:business)
    end
  end

  def cache_sensitive?
    false
  end

  def cache_sensitive_key(params)
  end

  def height=(value)
    super value.to_i
  end

  %i[heading subheading text].each do |key|
    define_method key do
      value = read_attribute(key)
      value.blank? ? '<br>' : value
    end
  end

  def link?
    (link_internal? && link_label? && link.present?) ||
    (link_external? && link_label? && link_external_url?)
  end

  def link_external_url=(value)
    value.to_s.match(/\Ahttp/) ? super(value.to_s) : super("http://#{value}")
  end

  def link_location
    if link_internal?
      link.pathname.blank? ? '/' : Rails.application.routes.url_helpers.website_custom_page_path(link.pathname)
    elsif link_external?
      link_external_url
    end
  end
end
