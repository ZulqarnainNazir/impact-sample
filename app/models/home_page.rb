class HomePage < Page
  store_accessor :settings,
    :layout_visible,
    :layout_theme,
    :reviews_visible,
    :reviews_theme

  validates :layout_theme, presence: true, inclusion: { in: %w[sidebar split fullWidth] }, if: :layout?
  validates :reviews_theme, presence: true, inclusion: { in: %w[basicCarousel columnsCarousel] }, if: :reviews?

  def layout?
    layout_visible == 'true'
  end

  def reviews?
    reviews_visible == 'true'
  end

  def name
    'Homepage'
  end
end
