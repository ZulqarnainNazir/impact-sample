class Website < ActiveRecord::Base
  include WebsiteFontDefaultsConcern

  store_accessor :settings,
   :background_color,
   :footer_injection,
   :foreground_color,
   :google_analytics_id,
   :head_injection,
   :link_color,
   :wrap_container,
   :h1_font_family,
   :h2_font_family,
   :h3_font_family,
   :h4_font_family,
   :h5_font_family,
   :h6_font_family,
   :paragraph_font_family,
   :blockquote_font_family,
   :lead_font_family,
   :h1_font_color,
   :h2_font_color,
   :h3_font_color,
   :h4_font_color,
   :h5_font_color,
   :h6_font_color,
   :paragraph_font_color,
   :blockquote_font_color,
   :lead_font_color,
   :h1_font_desk_size,
   :h2_font_desk_size,
   :h3_font_desk_size,
   :h4_font_desk_size,
   :h5_font_desk_size,
   :h6_font_desk_size,
   :paragraph_font_desk_size,
   :blockquote_font_desk_size,
   :lead_font_desk_size,
   :h1_font_mobile_size,
   :h2_font_mobile_size,
   :h3_font_mobile_size,
   :h4_font_mobile_size,
   :h5_font_mobile_size,
   :h6_font_mobile_size,
   :paragraph_font_mobile_size,
   :blockquote_font_mobile_size,
   :lead_font_mobile_size


  belongs_to :business, touch: true

  with_options as: :frame, dependent: :destroy do
    has_one :header_block
    has_one :footer_block
  end

  with_options dependent: :destroy do
    has_many :nav_links
    has_many :redirects
    has_many :webhosts
    has_many :webpages
  end

  has_one :about_page
  has_one :blog_page
  has_one :contact_page
  has_one :home_page
  has_many :custom_pages

  accepts_nested_attributes_for :business
  accepts_nested_attributes_for :header_block
  accepts_nested_attributes_for :footer_block
  accepts_nested_attributes_for :webpages, reject_if: proc { |a| a['_destroy'] == '1' || a['title'].blank? }

  with_options allow_destroy: true do
    accepts_nested_attributes_for :nav_links
    accepts_nested_attributes_for :webhosts, reject_if: proc { |a| a['id'].nil? && a['name'].blank? }
    accepts_nested_attributes_for :custom_pages, reject_if: proc { |a| a['title'].blank? }
  end

  validates :footer_block, presence: true
  validates :header_block, presence: true
  validates :subdomain, presence: true, exclusion: { in: %w[www] }, format: { with: /\A[[a-z][0-9]\-]+\z/ }, length: { in: 3..30 }, uniqueness: { case_sensitive: false }
  validates :webhosts, length: { maximum: 10 }

  validate do
    future_webhosts = webhosts.reject(&:marked_for_destruction?)
    future_primary_webhosts = future_webhosts.select(&:primary?)

    if future_primary_webhosts.length > 1
      errors.add :webhosts, :invalid_primary
    end
  end

  def webhost
    webhosts.primary.any? ? webhosts.primary.first : webhosts.first
  end

  def arranged_nav_links(location)
    ArrangedNavLinks.new(nav_links.send(location)).arrange
  end
end
