class AboutBlock < Block
  has_placed_image :about_block_image

  before_validation do
    self.about_block_image_placement_attributes = image_accessor_attributes if image_accessors?
  end

  def react_attributes
    super(about_block_image, about_block_image_placement)
  end
end
