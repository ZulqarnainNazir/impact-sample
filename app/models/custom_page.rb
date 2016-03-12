class CustomPage < Webpage
  store_accessor :settings, :hide_navigation

  validates :pathname, exclusion: { in: %w[about blog contact events feedback share] }
end
