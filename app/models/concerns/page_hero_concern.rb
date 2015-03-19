module PageHeroConcern
  extend ActiveSupport::Concern

  included do
    has_placed_image :hero_background

    store_accessor :settings,
      :hero_visible,
      :hero_theme,
      :hero_style,
      :hero_title,
      :hero_text,
      :hero_button

    validates :hero_theme, presence: true, inclusion: { in: %w[fullImage fullImageRight fullImageRightWell fullImageRightWellDark fullImageRightForm splitImage splitVideo] }, if: :hero?

    def hero?
      hero_visible != 'false'
    end
  end
end
