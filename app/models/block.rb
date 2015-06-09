class Block < ActiveRecord::Base
  include PlacedImageConcern

  store_accessor :settings, :background_color, :foreground_color, :link_color

  enum link_version: { link_none: 0, link_internal: 1, link_external: 2, }

  belongs_to :frame, polymorphic: true
  belongs_to :link, polymorphic: true

  validates :position, presence: true
  validates :theme, presence: true
  validates :type, presence: true, exclusion: { in: %w[Block] }

  before_validation do
    self.position = 0 unless position?
  end

  def self.default_scope
    order(position: :asc, created_at: :asc)
  end

  def key
    (SecureRandom.random_number*10**20).to_i
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
