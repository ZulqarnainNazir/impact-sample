class FooterBlock < Block
  store_accessor :settings, :background_color, :foreground_color, :link_color

  before_validation do
    self.theme = 'simple' unless theme?
  end

  def as_theme_json(business)
    as_json(methods: %i[background_color foreground_color link_color]).merge(
      name: business.name,
      pages: business.website.footer_pages.as_json,
      email: business.location.try(:email),
      phone: business.location.try(:phone),
      addressLineOne: business.location.try(:address_line_one),
      addressLineTwo: business.location.try(:address_line_two),
    )
  end
end
