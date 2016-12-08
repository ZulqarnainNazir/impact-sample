class FooterBlock < Block
  store_accessor :settings, :background_color, :foreground_color, :link_color
  after_initialize :set_defaults

  before_validation do
    self.theme = 'simple' unless theme?
  end

  def set_defaults
    self.settings  ||= {"background_color"=>"", "foreground_color"=>"", "link_color"=>"", "content_types"=>"", "content_category_ids"=>"", "content_tag_ids"=>""}
  end

  def as_theme_json(business)
    as_json(methods: %i[background_color foreground_color link_color type]).merge(
      name: business.name,
      pages: business.website.nav_links.footer.order(position: :asc),
      email: business.location.try(:email),
      phone: business.location.try(:phone_number),
      addressLineOne: business.location.try(:address_line_one),
      addressLineTwo: business.location.try(:address_line_two),
      hideEmail: business.location.try(:hide_email) || false,
      hidePhone: business.location.try(:hide_phone) || false,
      hideAddress: business.location.try(:hide_address) || false,
    )
  end
end
