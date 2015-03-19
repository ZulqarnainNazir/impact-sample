module PageSpecialtyConcern
  extend ActiveSupport::Concern

  included do
    has_placed_image :specialty_background

    store_accessor :settings,
      :specialty_visible,
      :specialty_theme,
      :specialty_heading,
      :specialty_subheading,
      :specialty_text,
      :specialty_button

    validates :specialty_theme, presence: true, inclusion: { in: %w[left right] }, if: :specialty?

    def specialty?
      specialty_visible != 'false'
    end
  end
end
