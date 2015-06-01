class Website < ActiveRecord::Base
  store_accessor :settings,
    :background_color,
    :footer_injection,
    :foreground_color,
    :google_analytics_id,
    :head_injection,
    :link_color

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
    has_one :about_page
    has_one :blog_page
    has_one :contact_page
    has_one :home_page
  end

  accepts_nested_attributes_for :business
  accepts_nested_attributes_for :header_block
  accepts_nested_attributes_for :footer_block

  with_options allow_destroy: true do
    accepts_nested_attributes_for :home_page,     reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :about_page,    reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :blog_page,     reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :contact_page,  reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :nav_links,     reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :webhosts,      reject_if: proc { |a| a['_destroy'] == '1' || a['id'].nil? && a['name'].blank? }
    accepts_nested_attributes_for :webpages,      reject_if: proc { |a| a['_destroy'] == '1' || a['title'].blank? }
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

  before_validation do
    self.build_footer_block(frame: self) unless footer_block
    self.build_header_block(frame: self) unless header_block
    self.subdomain = self.class.available_subdomain(business.name) if business.try(:name?) && !subdomain?
  end

  def self.available_subdomain(subdomain)
    subdomain = subdomain.gsub(/'/, '').parameterize[0..26]

    if exists?(subdomain: subdomain)
      n = 1
      while exists?(subdomain: "#{subdomain}-#{n}") do
        n += 1
      end
      "#{subdomain}-#{n}"
    else
      subdomain
    end
  end

  def webhost
    webhosts.primary.any? ? webhosts.primary.first : webhosts.first
  end

  def arranged_nav_links(location)
    links = nav_links.select do |link|
      link.location == location.to_s
    end

    links.each do |link|
      link.index = (SecureRandom.random_number*10**10).to_i if link.index.blank?
      link.key = SecureRandom.uuid if link.key.blank?
    end

    links.each do |link|
      if link.parent_key.blank?
        parent = links.find { |l| l.persisted? && l.id == link.parent_id }
        link.parent_key = parent.key if parent
      end
    end

    roots = links.select do |link|
      link.parent_key.blank?
    end

    arrange_nav_links(roots, links)
  end

  def arrange_nav_links(links, available_links)
    links.map do |link|
      children = available_links.select do |s|
        s.parent_key == link.key
      end
      link.cached_children = arrange_nav_links(children, available_links)
      link
    end.sort do |a, b|
      a.position.to_i <=> b.position.to_i
    end
  end
end
