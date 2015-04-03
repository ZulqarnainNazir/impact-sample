class HeroBlock < Block
  store_accessor :settings, :background_color, :foreground_color

  has_placed_image :hero_block_image

  before_validation do
    self.theme = 'left' unless theme?
    self.style = 'light' unless style?
    self.hero_block_image_placement_attributes = image_accessor_attributes if image_accessors?
  end

  def react_attributes
    super(hero_block_image, hero_block_image_placement).merge(
      background_color: background_color,
      foreground_color: foreground_color,
    )
  end

  def css_class
    style == 'dark' ? 'hero-dark' : ''
  end
end
