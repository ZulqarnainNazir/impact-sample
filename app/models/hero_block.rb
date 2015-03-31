class HeroBlock < Block
  has_placed_image :hero_block_image

  before_validation do
    self.theme = 'left' unless theme?
    self.hero_block_image_placement_attributes = image_accessor_attributes if image_accessors?
  end

  def react_attributes
    super(hero_block_image, hero_block_image_placement)
  end
end
