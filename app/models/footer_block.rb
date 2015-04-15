class FooterBlock < Block
  store_accessor :settings, :background_color, :foreground_color, :link_color

  before_validation do
    self.theme = 'simple' unless theme?
  end

  def react_attributes(business)
    super.merge(
      background_color: background_color,
      foreground_color: foreground_color,
      link_color: link_color,
      name: business.name,
      pages: business.website.webpages.select(:id, :name),
      email: business.location.try(:email),
      phone: business.location.try(:phone),
      address_line_one: business.location.try(:address_line_one),
      address_line_two: business.location.try(:address_line_two),
    )
  end
end
