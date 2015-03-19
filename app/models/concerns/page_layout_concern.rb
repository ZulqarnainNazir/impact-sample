module PageLayoutConcern
  extend ActiveSupport::Concern

  included do
    store_accessor :settings,
      :layout_visible,
      :layout_theme

    validates :layout_theme, presence: true, inclusion: { in: %w[sidebar split fullWidth] }, if: :layout?

    def layout?
      layout_visible != 'false'
    end
  end
end
