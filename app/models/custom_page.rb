class CustomPage < Webpage
  store_accessor :settings, :hide_navigation, :no_index

  validates :pathname, exclusion: { in: %w[about blog contact events feedback share] }
end
