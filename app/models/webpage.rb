class Webpage < ActiveRecord::Base
  attr_accessor :image_business, :image_user, :cached_webpages
  
  store_accessor :settings, :block_type_order, :external_line_id, :sidebar_position

  has_many :blocks, as: :link

  belongs_to :website, touch: true

  validates :pathname, uniqueness: { scope: :website, case_sensitive: false }
  validates :pathname, absence: true, if: :home_page?
  validates :pathname, presence: true, format: { with: /\A\w+[\w\-\/]*\w+\z/ }, unless: :home_page?
  validates :title, presence: true
  validates :type, presence: true, exclusion: { in: %w[Webpage] }

  before_validation do
    self.name = title if !name? && title?

    unless type == 'HomePage'
      self.pathname = title.parameterize if !pathname? && title?
    end
  end

  def self.custom
    where(type: 'CustomPage')
  end

  def cached_webpages_json
    cached_webpages.as_json
  end

  def home_page?
    type == 'HomePage'
  end

  def block_types
    order = block_type_order.to_s.split(',')
    %w[hero tagline call_to_action specialty content feed interior].each do |type|
      order << type unless order.include?(type)
    end
    order
  end
end
