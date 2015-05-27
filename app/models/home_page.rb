class HomePage < Webpage
  store_accessor :settings, :call_to_action_blocks_per_row

  with_options as: :frame, dependent: :destroy do
    has_many :call_to_action_blocks
    has_many :content_blocks
    has_many :sidebar_content_blocks
    has_many :specialty_blocks
    has_many :tagline_blocks
    has_one :feed_block
    has_one :hero_block
    has_one :sidebar_events_block
    has_one :sidebar_feed_block
  end

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :call_to_action_blocks
    accepts_nested_attributes_for :content_blocks
    accepts_nested_attributes_for :feed_block
    accepts_nested_attributes_for :hero_block
    accepts_nested_attributes_for :sidebar_content_blocks
    accepts_nested_attributes_for :sidebar_events_block
    accepts_nested_attributes_for :sidebar_feed_block
    accepts_nested_attributes_for :specialty_blocks
    accepts_nested_attributes_for :tagline_blocks
  end

  before_validation on: :create do
    if website && website.business
      self.hero_block_attributes = default_hero_block_attributes(website.business) unless hero_block
      self.tagline_blocks_attributes = [default_tagline_block_attributes(website.business)] unless tagline_blocks.any?
    end
  end

  def blocks_count
    [
      call_to_action_blocks,
      content_blocks,
      feed_block,
      hero_block,
      sidebar_content_blocks,
      sidebar_events_block,
      sidebar_feed_block,
      specialty_blocks,
      tagline_blocks,
    ].flatten.count
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

  def sidebar_position
    position = super
    position.present? ? position : 'right'
  end
end
