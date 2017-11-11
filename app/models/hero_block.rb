class HeroBlock < Block
  validates :height, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }, allow_blank: true

  before_validation do
    self.theme = 'left' unless theme?
    self.style = 'transparent' unless style?
    self.layout = 'default' unless layout?
  end
end
