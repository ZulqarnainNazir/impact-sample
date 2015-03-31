class ContactPage < Webpage
  with_options as: :frame, dependent: :destroy do
    has_one :contact_block
  end

  accepts_nested_attributes_for :contact_block

  before_validation on: :setup do
    if website.business
      self.contact_block_attributes = default_contact_block_attributes(website.business)
    end
  end

  def default_contact_block_attributes(business)
    {
      theme: 'left',
      text: business.description,
    }
  end
end
