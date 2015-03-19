class Page < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :website

  validates :pathname, uniqueness: { scope: :website, case_sensitive: false }
  validates :pathname, absence: true, if: :home_page?
  validates :pathname, presence: true, format: { with: /\A\w+[\w\-\/]*\w+\z/ }, unless: :home_page?
  validates :title, presence: true
  validates :type, presence: true, inclusion: { in: %w[HomePage AboutPage ContactPage CustomPage] }

  def self.active
    where(active: true)
  end

  def self.custom
    where(type: 'CustomPage')
  end

  def self.default
    where.not(type: 'CustomPage')
  end

  def self.newest
    order(created_at: :desc)
  end

  def home_page?
    type == 'HomePage'
  end

  def about_page?
    type == 'AboutPage'
  end

  def contact_page?
    type == 'ContactPage'
  end

  def custom_page?
    type == 'CustomPage'
  end
end
