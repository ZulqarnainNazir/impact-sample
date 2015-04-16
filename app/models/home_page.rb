class HomePage < Webpage
  with_options as: :frame, dependent: :destroy do
    has_many :call_to_action_blocks
    has_many :content_blocks
    has_many :specialty_blocks
    has_many :tagline_blocks
    has_one :hero_block
  end

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :hero_block
    accepts_nested_attributes_for :tagline_blocks
    accepts_nested_attributes_for :specialty_blocks
    accepts_nested_attributes_for :call_to_action_blocks
    accepts_nested_attributes_for :content_blocks
  end

  before_validation on: :setup do
    if website.business
      self.hero_block_attributes = default_hero_block_attributes(website.business)
      self.tagline_blocks_attributes = [default_tagline_block_attributes(website.business)]
    end
  end

  def default_hero_block_attributes(business)
    {
      heading: business.name,
      text: business.description,
    }.reject do |key, value|
      value.blank?
    end
  end

  def default_tagline_block_attributes(business)
    {
      text: business.tagline,
    }.reject do |key, value|
      value.blank?
    end
  end
end
