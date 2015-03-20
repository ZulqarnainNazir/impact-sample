module PageLayoutConcern
  extend ActiveSupport::Concern

  THEMES = %w[sidebar split fullWidth]

  included do
    store_accessor :settings,
      :layout_visible,
      :layout_theme

    validates :layout_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.layout_theme = THEMES.first unless THEMES.include?(layout_theme)
    end

    def layout?
      layout_visible != 'false'
    end
  end
end
