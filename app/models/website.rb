class Website < ActiveRecord::Base
  store_accessor :settings,
    :background_color,
    :footer_injection,
    :foreground_color,
    :google_analytics_id,
    :head_injection,
    :link_color,
    :wrap_container

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
  accepts_nested_attributes_for :webpages

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
