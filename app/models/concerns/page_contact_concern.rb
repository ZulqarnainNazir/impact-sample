module PageContactConcern
  extend ActiveSupport::Concern

  included do
    store_accessor :settings,
      :contact_theme,
      :text

    validates :contact_theme, presence: true, inclusion: { in: %w[right banner inline] }
  end
end
