class BlogPage < Webpage
  store_accessor :settings

  with_options as: :frame, dependent: :destroy do
    has_many :sidebar_content_blocks
    has_one :feed_block
    has_one :sidebar_feed_block
  end

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :feed_block
    accepts_nested_attributes_for :sidebar_content_blocks
    accepts_nested_attributes_for :sidebar_feed_block
  end

  validates :feed_block, presence: true

  def blocks_count
    [
      feed_block,
      sidebar_content_blocks,
      sidebar_feed_block,
    ].flatten.count
  end

  def default_feed_block_attributes
    { items_limit: 4 }
  end

  def sidebar_position
    position = super
    position.present? ? position : 'right'
  end
end
