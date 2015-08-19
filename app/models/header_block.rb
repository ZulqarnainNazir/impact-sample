class HeaderBlock < Block
  include JsonHelper

  store_accessor :settings, :background_color, :foreground_color, :link_color, :logo_height, :logo_horizontal_position, :logo_vertical_position, :navigation_horizontal_position, :contact_position, :navbar_location

  before_validation do
    self.theme = 'inline' unless theme?
    self.style = 'dark' unless theme?
    self.navbar_location = 'static' unless navbar_location.present?
    self.logo_horizontal_position = 'left' unless logo_horizontal_position.present?
    self.logo_vertical_position = 'inside' unless logo_vertical_position.present?
    self.navigation_horizontal_position = 'right' unless navigation_horizontal_position.present?
  end

  def as_theme_json(business)
    as_json(methods: %i[background_color foreground_color link_color logo_height logo_horizontal_position logo_vertical_position navigation_horizontal_position contact_position navbar_location type]).merge(
      name: business.name,
      email: business.location.try(:email),
      phone: business.location.try(:phone_number),
      addressLineOne: business.location.try(:address_line_one),
      addressLineTwo: business.location.try(:address_line_two),
      hideEmail: business.location.try(:hide_email) || false,
      hidePhone: business.location.try(:hide_phone) || false,
      hideAddress: business.location.try(:hide_address) || false,
      pages: as_nested_json(business.website.arranged_nav_links(:header), methods: %i[cached_children]),
      logoSmall: business.logo.try(:attachment_url, :logo_small),
      logoMedium: business.logo.try(:attachment_url, :logo_medium),
      logoLarge: business.logo.try(:attachment_url, :logo_large),
      logoJumbo: business.logo.try(:attachment_url, :logo_jumbo),
    )
  end

  def css_class
    style == 'dark' ?  'navbar-inverse' : 'navbar-default'
  end
end
