module PageTaglineConcern
  extend ActiveSupport::Concern

  THEMES = %w[left center contain]

  included do
    store_accessor :settings,
      :tagline_visible,
      :tagline_theme,
      :tagline_text,
      :tagline_button

    validates :tagline_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.tagline_theme = THEMES.first unless THEMES.include?(tagline_theme)
    end

    def tagline?
      tagline_visible != 'false'
    end
  end
end
