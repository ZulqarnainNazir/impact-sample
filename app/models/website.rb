class Website < ActiveRecord::Base
  store_accessor :settings, :google_analytics_id

  belongs_to :business, touch: true

  with_options as: :frame do
    has_one :header_block
    has_one :footer_block
  end

  with_options dependent: :destroy do
    has_many :webhosts
    has_many :webpages
    has_one :about_page
    has_one :contact_page
    has_one :home_page
  end

  accepts_nested_attributes_for :business
  accepts_nested_attributes_for :header_block
  accepts_nested_attributes_for :footer_block

  with_options allow_destroy: true do
    accepts_nested_attributes_for :home_page,     reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :about_page,    reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :contact_page,  reject_if: proc { |a| a['_destroy'] == '1' }
    accepts_nested_attributes_for :webhosts,      reject_if: proc { |a| a['_destroy'] == '1' || a['id'].nil? && a['name'].blank? }
    accepts_nested_attributes_for :webpages,      reject_if: proc { |a| a['_destroy'] == '1' || a['title'].blank? }
  end

  validates :subdomain,
    exclusion: { in: %w[www] },
    format: { with: /\A[[a-z][0-9]\-]+\z/ },
    length: { in: 3..30 },
    presence: true,
    uniqueness: { case_sensitive: false }
  validates :webhosts,
    length: { maximum: 10 }

  validate do
    future_webhosts = webhosts.reject(&:marked_for_destruction?)
    future_primary_webhosts = future_webhosts.select(&:primary?)

    if future_webhosts.length > 1 && future_primary_webhosts.length != 1
      errors.add :webhosts, :invalid_primary
    end
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

  def default_header_block_attributes(business)
    {
    }.reject do |key, value|
      value.blank?
    end
  end

  def default_footer_block_attributes(business)
    {
    }.reject do |key, value|
      value.blank?
    end
  end

  def header_pages
    if header_menu.blank?
      webpages.where.not(type: 'HomePage').map do |root|
        root.cached_webpages = []
        root
      end
    else
      menu = header_menu || []
      root_ids = menu.select { |p| p['parent_id'].nil? }.map { |p| p['id'] }
      roots = webpages.where.not(type: 'HomePage').where(id: root_ids).sort do |ap, bp|
        am = menu.find { |p| p['id'].to_i == ap.id }
        bm = menu.find { |p| p['id'].to_i == bp.id }
        am['position'] <=> bm['position']
      end
      roots.map do |root|
        children_ids = menu.select { |p| p['parent_id'].to_i == root.id }.map { |p| p['id'] }
        children = webpages.where.not(type: 'HomePage').where(id: children_ids)
        root.cached_webpages = children.sort do |ap, bp|
          am = menu.find { |p| p['id'].to_i == ap.id }
          bm = menu.find { |p| p['id'].to_i == bp.id }
          am['position'] <=> bm['position']
        end
        root
      end
    end
  end

  def footer_pages
    if footer_menu.blank?
      webpages.where.not(type: 'HomePage')
    else
      menu = footer_menu || []
      footer_ids = menu.select { |p| p['parent_id'].nil? }.map { |p| p['id'] }
      webpages.where.not(type: 'HomePage').where(id: footer_ids).sort do |ap, bp|
        am = menu.find { |p| p['id'].to_i == ap.id }
        bm = menu.find { |p| p['id'].to_i == bp.id }
        am['position'] <=> bm['position']
      end
    end
  end

  def header_excluded_pages
    if header_menu.blank?
      []
    else
      webpages.where.not(type: 'HomePage', id: header_menu.map { |p| p['id'] })
    end
  end

  def footer_excluded_pages
    if footer_menu.blank?
      []
    else
      webpages.where.not(type: 'HomePage', id: footer_menu.map { |p| p['id'] })
    end
  end
end
