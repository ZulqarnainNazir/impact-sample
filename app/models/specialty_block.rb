class SpecialtyBlock < Block
  has_placed_image :specialty_block_image

  before_validation do
    self.theme = 'left' unless theme?
    self.specialty_block_image_placement_attributes = image_accessor_attributes if image_accessors?
  end

  def react_attributes
    super(specialty_block_image, specialty_block_image_placement)
  end
end
