module PageTeamConcern
  extend ActiveSupport::Concern

  included do
    store_accessor :settings,
      :team_visible,
      :team_theme

    validates :team_theme, presence: true, inclusion: { in: %w[vertical horizontal] }, if: :team?

    def team?
      team_visible != 'false'
    end
  end
end
