module PageReviewsConcern
  extend ActiveSupport::Concern

  included do
    store_accessor :settings,
      :reviews_visible,
      :reviews_theme

    validates :reviews_theme, presence: true, inclusion: { in: %w[basicCarousel columnsCarousel] }, if: :reviews?

    def reviews?
      reviews_visible != 'false'
    end
  end
end
