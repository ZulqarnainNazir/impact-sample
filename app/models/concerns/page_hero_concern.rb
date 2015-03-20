module PageHeroConcern
  extend ActiveSupport::Concern

  THEMES = %w[fullImage fullImageRight fullImageRightWell fullImageRightWellDark fullImageRightForm splitImage splitVideo]

  included do
    has_placed_image :hero_background

    store_accessor :settings,
      :hero_visible,
      :hero_theme,
      :hero_style,
      :hero_title,
      :hero_text,
      :hero_button

    validates :hero_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.hero_theme = THEMES.first unless THEMES.include?(hero_theme)
    end

    def hero?
      hero_visible != 'false'
    end
  end
end
