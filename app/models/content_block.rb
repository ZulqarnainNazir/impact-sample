class ContentBlock < Block
  has_placed_image :content_block_image

  before_validation do
    self.content_block_image_placement_attributes = image_accessor_attributes if image_accessors?
  end

  def react_attributes
    super(content_block_image, content_block_image_placement)
  end
end
