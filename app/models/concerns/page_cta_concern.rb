module PageCtaConcern
  extend ActiveSupport::Concern

  THEMES = %w[simple]

  included do
    has_placed_image :cta_background_01
    has_placed_image :cta_background_02
    has_placed_image :cta_background_03

    store_accessor :settings,
      :cta_visible,
      :cta_theme,
      :cta_title_01,
      :cta_text_01,
      :cta_button_01,
      :cta_title_02,
      :cta_text_02,
      :cta_button_02,
      :cta_title_03,
      :cta_text_03,
      :cta_button_03

    validates :cta_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.cta_theme = THEMES.first unless THEMES.include?(cta_theme)
    end

    def cta?
      cta_visible != 'false'
    end
  end
end
