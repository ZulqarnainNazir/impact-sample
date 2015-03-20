module PageTeamConcern
  extend ActiveSupport::Concern

  THEMES = %w[vertical horizontal]

  included do
    store_accessor :settings,
      :team_visible,
      :team_theme

    validates :team_theme, presence: true, inclusion: { in: THEMES }

    before_validation do
      self.team_theme = THEMES.first unless THEMES.include?(team_theme)
    end

    def team?
      team_visible != 'false'
    end
  end
end
