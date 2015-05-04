class ContactPage < Webpage
  with_options as: :frame, dependent: :destroy do
    has_one :contact_block
  end

  accepts_nested_attributes_for :contact_block

  before_validation do
    if website && website.business && !contact_block
      self.contact_block_attributes = default_contact_block_attributes(website.business)
    end
  end

  def blocks_count
    [
      contact_block,
    ].count
  end

  def default_contact_block_attributes(business)
    {
      text: business.description,
    }.reject do |key, value|
      value.blank?
    end
  end
end
