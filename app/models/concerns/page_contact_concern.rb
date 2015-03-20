module PageContactConcern
  extend ActiveSupport::Concern

  THEMES = %w[right banner inline]

  included do
    store_accessor :settings,
      :contact_theme,
      :text

    validates :contact_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.contact_theme = THEMES.first unless THEMES.include?(contact_theme)
    end
  end
end
