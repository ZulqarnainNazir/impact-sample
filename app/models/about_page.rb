class AboutPage < Page
  include PageAboutConcern
  include PageTeamConcern

  def name
    'About'
  end
end
