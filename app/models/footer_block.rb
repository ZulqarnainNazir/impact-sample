class FooterBlock < Block
  SETTINGS = [
    :background_color,
    :foreground_color,
    :link_color,
    :left_label_internal_target,
    :left_label_text,
    :right_label_internal_target,
    :right_label_text,
    :left_number_of_feed_items,
    :left_category_ids,
    :left_custom_class,
    :left_content_types,
    :right_number_of_feed_items,
    :right_category_ids,
    :right_custom_class,
    :right_content_types
  ]

  store_accessor :settings, *SETTINGS
  after_initialize :set_defaults

  before_validation do
    self.theme = 'simple' unless theme?
  end

  before_save do
    self.right_category_ids = self.right_category_ids.to_s.split(',')
    self.left_category_ids = self.left_category_ids.to_s.split(',')
    self.left_number_of_feed_items = self.left_number_of_feed_items.present? ? self.left_number_of_feed_items : 3
    self.right_number_of_feed_items = self.right_number_of_feed_items.present? ? self.right_number_of_feed_items : 3
  end

  def set_defaults
    self.settings ||= {
      "background_color" => "",
      "foreground_color" => "",
      "link_color" => "",
      "content_types" => "",
      "content_category_ids" => "",
      "content_tag_ids" => ""
    }
  end

  def as_theme_json(business)
    as_json(methods: SETTINGS.push(:type)).merge(
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
