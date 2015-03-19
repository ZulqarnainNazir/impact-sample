module PageAboutConcern
  extend ActiveSupport::Concern

  included do
    has_placed_image :about_background

    store_accessor :settings,
      :about_visible,
      :about_theme,
      :about_heading,
      :about_subheading,
      :about_text

    validates :about_theme, presence: true, inclusion: { in: %w[banner left] }, if: :about?

    def about?
      about_visible != 'false'
    end
  end
end
