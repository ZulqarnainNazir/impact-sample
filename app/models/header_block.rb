class HeaderBlock < Block
  store_accessor :settings, :background_color, :foreground_color, :link_color

  has_placed_image :header_block_image

  before_validation do
    self.theme = 'inline' unless theme?
    self.style = 'dark' unless theme?
  end

  def as_theme_json(business)
    as_json(methods: %i[background_color foreground_color link_color]).merge(
      name: business.name,
      pages: business.website.header_pages.as_json(methods: %i[cached_webpages_json]),
      logoSmall: business.logo.try(:attachment_url, :logo_small),
      logoMedium: business.logo.try(:attachment_url, :logo_medium),
      logoLarge: business.logo.try(:attachment_url, :logo_large),
    )
  end

  def css_class
    style == 'dark' ?  'navbar-inverse' : 'navbar-default'
  end
end
