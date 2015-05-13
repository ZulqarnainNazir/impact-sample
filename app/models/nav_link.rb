class NavLink < ActiveRecord::Base
  attr_accessor :cached_children, :index, :key, :parent_key

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
  validates :webpage, presence: true, if: :internal?
  validates :website, presence: true

  before_validation do
    self.url = "http://#{url}" if url? && !url.match(/\Ahttp/)
    self.label = webpage.name if !label? && internal? && webpage
    self.label = url if !label? && external? && url?
  end
end
