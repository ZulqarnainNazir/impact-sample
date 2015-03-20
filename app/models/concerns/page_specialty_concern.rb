module PageSpecialtyConcern
  extend ActiveSupport::Concern

  THEMES = %w[left right]

  included do
    has_placed_image :specialty_background

    store_accessor :settings,
      :specialty_visible,
      :specialty_theme,
      :specialty_heading,
      :specialty_subheading,
      :specialty_text,
      :specialty_button

    validates :specialty_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.specialty_theme = THEMES.first unless THEMES.include?(specialty_theme)
    end

    def specialty?
      specialty_visible != 'false'
    end
  end
end
