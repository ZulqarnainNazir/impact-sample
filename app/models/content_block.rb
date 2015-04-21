class ContentBlock < Block
  has_placed_image :content_block_image

  def self.default_scope
    order(created_at: :asc)
  end
end
