class AboutPage < Webpage
  with_options as: :frame, dependent: :destroy do
    has_one :about_block
    has_one :team_block
  end

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :about_block
    accepts_nested_attributes_for :team_block
  end

  before_validation on: :setup do
    if website.business
      self.about_block_attributes = default_about_block_attributes(website.business)
    end
  end

  def default_about_block_attributes(business)
    {
      theme: 'left',
      heading: business.name,
      text: business.description,
    }.reject do |key, value|
      value.blank?
    end
  end
end
