class GalleryImage < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :gallery, touch: true

  has_placed_image :gallery_image

  validates :gallery, presence: true
  validates :gallery_image_placement, presence: true

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end
end
