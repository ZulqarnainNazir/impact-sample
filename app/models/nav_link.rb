class NavLink < ActiveRecord::Base
  attr_accessor :cached_children, :index, :key, :parent_key, :internal_value

  enum location: {
    header: 0,
    footer: 1,
  }

  enum kind: {
    internal: 0,
    external: 1,
    dropdown: 2,
  }

  belongs_to :website
  belongs_to :webpage

  has_ancestry

  validates :kind, presence: true
  validates :label, presence: true
  validates :location, presence: true
  validates :url, presence: true, if: :external?
  validates :webpage, presence: true, if: :internal?, unless: :webpath?
  validates :webpath, presence: true, if: :internal?, unless: :webpage
  validates :website, presence: true

  before_validation do
    self.url = "http://#{url}" if url? && !url.match(/\Ahttp/)
    self.label = webpage.name if !label? && internal? && webpage
    self.label = webpath if !label? && internal? && webpath?
    self.label = url if !label? && external? && url?
  end

  def internal_value
    webpage_id? ? webpage_id : webpath
  end

  def internal_value=(value)
    if value.to_i.to_s == value
      self.webpage_id = value
      self.webpath = nil
    else
      self.webpath = value
      self.webpage_id = nil
    end
  end
end
