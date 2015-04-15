class HeaderBlock < Block
  store_accessor :settings, :background_color, :foreground_color, :link_color

  has_placed_image :header_block_image

  before_validation do
    self.theme = 'inline' unless theme?
    self.style = 'dark' unless theme?
    self.header_block_image_placement_attributes = image_accessor_attributes if image_accessors?
  end

  def react_attributes(business)
    super(header_block_image).merge(
      background_color: background_color,
      foreground_color: foreground_color,
      link_color: link_color,
      name: business.name,
      pages: business.website.webpages.where.not(type: 'HomePage').select(:id, :name),
      logoSmall: business.logo.try(:attachment_url, :small),
      logoMedium: business.logo.try(:attachment_url, :medium),
      logoLarge: business.logo.try(:attachment_url, :large),
    )
  end

  def css_class
    style == 'dark' ?  'navbar-inverse' : 'navbar-default'
  end
end
