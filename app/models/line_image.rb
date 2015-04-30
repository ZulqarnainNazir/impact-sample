class LineImage < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :line, touch: true

  has_placed_image :line_image

  # validates :line, presence: true
  validates :line_image_placement, presence: true
end
