class AboutPage < Page
  has_placed_image :about_background

  store_accessor :settings,
    :about_visible,
    :about_theme,
    :about_heading,
    :about_subheading,
    :about_text,
    :team_visible,
    :team_theme

  validates :about_theme, presence: true, inclusion: { in: %w[banner left] }, if: :about?
  validates :team_theme, presence: true, inclusion: { in: %w[vertical horizontal] }, if: :team?

  def about?
    about_visible != 'false'
  end

  def team?
    team_visible != 'false'
  end

  def name
    'About'
  end
end
