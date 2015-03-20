module PageReviewsConcern
  extend ActiveSupport::Concern

  THEMES = %w[basicCarousel columnsCarousel]

  included do
    store_accessor :settings,
      :reviews_visible,
      :reviews_theme

    validates :reviews_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.reviews_theme = THEMES.first unless THEMES.include?(reviews_theme)
    end

    def reviews?
      reviews_visible != 'false'
    end
  end
end
