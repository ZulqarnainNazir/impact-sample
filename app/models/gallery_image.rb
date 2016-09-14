class GalleryImage < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :gallery, touch: true

  has_placed_image :gallery_image

  validates :gallery_image_placement, presence: true

  def to_generic_param
    {
      year: created_at.strftime('%Y'),
      month: created_at.strftime('%m'),
      day: created_at.strftime('%d'),
      id: id,
      slug: gallery_image.title.parameterize
    }
  end
end
