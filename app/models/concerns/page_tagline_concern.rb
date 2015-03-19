module PageTaglineConcern
  extend ActiveSupport::Concern

  included do
    store_accessor :settings,
      :tagline_visible,
      :tagline_theme,
      :tagline_text,
      :tagline_button

    validates :tagline_theme, presence: true, inclusion: { in: %w[left center contain] }, if: :tagline?

    def tagline?
      tagline_visible != 'false'
    end
  end
end
