class HeroBlock < Block
  store_accessor :settings, :background_color, :foreground_color

  has_placed_image :hero_block_image

  before_validation do
    self.theme = 'left' unless theme?
    self.style = 'light' unless style?
  end

  def css_class
    style == 'dark' ? 'hero-dark' : ''
  end
end
