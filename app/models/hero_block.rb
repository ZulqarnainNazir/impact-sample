class HeroBlock < Block
  store_accessor :settings, :background_color, :foreground_color

  has_placed_image :hero_block_image

  before_validation do
    self.theme = 'left' unless theme?
    self.style = 'light' unless style?
    self.layout = 'default' unless layout?
  end

  def css_class
    "layout-#{layout}" + (style == 'dark' ? ' hero-dark' : '')
  end
end
