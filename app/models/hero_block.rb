class HeroBlock < Block
  before_validation do
    self.theme = 'left' unless theme?
    self.style = 'light' unless style?
    self.layout = 'default' unless layout?
  end

  def css_class
    "layout-#{layout}" + (style == 'dark' ? ' hero-dark' : '')
  end
end
