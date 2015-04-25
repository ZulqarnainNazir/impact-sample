class GalleryImage < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :gallery, touch: true

  has_placed_image :gallery_image

  validates :gallery, presence: true
  validates :gallery_image_placement, presence: true
end
