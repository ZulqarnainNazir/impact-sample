class FooterBlock < Block
  before_validation do
    self.theme = 'simple' unless theme?
  end

  def react_attributes(business)
    super.merge(
      name: business.name,
      pages: business.website.webpages.select(:id, :name),
      email: business.location.try(:email),
      phone: business.location.try(:phone),
      address_line_one: business.location.try(:address_line_one),
      address_line_two: business.location.try(:address_line_two),
    )
  end
end
