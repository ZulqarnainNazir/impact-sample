module PageAboutConcern
  extend ActiveSupport::Concern

  THEMES = %w[banner left]

  included do
    has_placed_image :about_background

    store_accessor :settings,
      :about_visible,
      :about_theme,
      :about_heading,
      :about_subheading,
      :about_text

    validates :about_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.about_theme = THEMES.first unless THEMES.include?(about_theme)
    end

    def about?
      about_visible != 'false'
    end
  end
end
