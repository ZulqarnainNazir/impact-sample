class ContentBlock < Block
  has_placed_image :content_block_image

  before_validation do
    self.theme = 'left' unless theme?
  end
end
