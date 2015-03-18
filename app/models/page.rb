class Page < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :website

  has_placed_image :hero_background

  store_accessor :settings,
    :hero_visible,
    :hero_theme,
    :hero_style,
    :hero_title,
    :hero_text,
    :hero_button,
    :tagline_visible,
    :tagline_theme,
    :tagline_text,
    :tagline_button

  validates :pathname, uniqueness: { scope: :website, case_sensitive: false }
  validates :pathname, absence: true, if: :home_page?
  validates :pathname, presence: true, format: { with: /\A\w+[\w\-\/]*\w+\z/ }, unless: :home_page?
  validates :title, presence: true
  validates :type, presence: true, inclusion: { in: %w[HomePage AboutPage ContactPage CustomPage] }
  validates :hero_theme, presence: true, inclusion: { in: %w[fullImage fullImageRight fullImageRightWell fullImageRightWellDark fullImageRightForm splitImage splitVideo] }, if: :hero?
  validates :tagline_theme, presence: true, inclusion: { in: %w[left center contain] }, if: :tagline?

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

  def hero?
    hero_visible != 'false'
  end

  def tagline?
    tagline_visible != 'false'
  end
end
